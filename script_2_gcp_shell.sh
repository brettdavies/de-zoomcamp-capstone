#!/bin/bash

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##  These commands are run inside a Google Cloud Shell session  ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

echo -e "\nExecuting script_2_gcp_shell.sh in a Google Cloud Shell session"

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                         Set Variables                        ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
# Set Project ID path variable
project_id_path="$HOME/project_id.env"

# Check if the variable is not set
if [ -z "$project_id" ]; then
    # Check if the file exists and is not empty
    if [ -s "$project_id_path" ]; then
        # If the file exists and isn't empty, write the file to the variable
        export project_id=$(cat "$project_id_path")
    else
        # If the file doesn't exist or is empty, write the variable to the file
        echo "Please enter the value for the project_id variable:"
        read project_id
        echo "$project_id" > "$project_id_path"
    fi
else
    # If the variable is already set, check if the file exists and is not empty.
    if [ -s "$project_id_path" ]; then
        # If the file exists and is not empty, do nothing.
        :
    else
        # If the file doesn't exist or is empty, write the variable to the file
        echo "$project_id" > "$project_id_path"
    fi
fi

# Use the project_id variable in your script as needed
echo "GCP Project ID: $project_id"

# Set ssh public key path variable
pub_key_path="$HOME/.ssh/$(whoami)_$project_id.pub"

# Check if the ssh public key file exists and is not empty
if [ -s "$pub_key_path" ]; then
    # If the file exists and is not empty, do nothing.
    :
else
    # Create a ssh key
    ssh-keygen -t ed25519 -f ~/.ssh/"$(whoami)_$project_id" -C $(whoami) -N "" -q
fi
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                              End                             ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                Configure Google Cloud Services               ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
gcloud config set project $project_id

# Query for the ssh key in the existing ssh keys in the GCP Project
output=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items.value)" | grep "$(cat ~/.ssh/"$(whoami)_$project_id".pub)")

# If the ssh key doesn't exist in the GCS project metadata, then upload it. 
if [ -z "$output" ]; then
    gcloud compute project-info add-metadata \
    --metadata ssh-keys="$(gcloud compute project-info describe \
    --format="value(commonInstanceMetadata.items.filter(key:ssh-keys).firstof(value))")
    $(whoami):$(cat ~/.ssh/"$(whoami)_$project_id".pub)"
    echo "The ssh key has been added to the GCP project metadata"
else
    echo "The ssh key is already in the GCP project metadata"
fi

# Create a service account named tf-serviceaccount 
gcloud iam service-accounts create tf-serviceaccount --description="service account for terraform" --display-name="terraform_service_account"

# List accounts to ensure the service account was successfully created
# gcloud iam service-accounts list

# Create key for the service account to use when provisioning and store them in the auth folder.
gcloud iam service-accounts keys create ~/auth/google-key.json --iam-account tf-serviceaccount@$project_id.iam.gserviceaccount.com

# These lines are adding IAM policy bindings.
# The 'gcloud projects add-iam-policy-binding' command is used to add an IAM policy binding to the IAM policy for a project, which grants a role to a member.
# In this case, the member is a service account with the email `tf-serviceaccount@$project_id.iam.gserviceaccount.com`, where `$project_id` is the ID of the project.
# The script grants the service account several roles. These roles grant the service account various permissions to access and manage resources within the project.
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:tf-serviceaccount@$project_id.iam.gserviceaccount.com --role roles/viewer --format="value(binding)"
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:tf-serviceaccount@$project_id.iam.gserviceaccount.com --role roles/serviceusage.serviceUsageConsumer --format="value(binding)"
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:tf-serviceaccount@$project_id.iam.gserviceaccount.com --role roles/storage.admin --format="value(binding)"
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:tf-serviceaccount@$project_id.iam.gserviceaccount.com --role roles/storage.objectAdmin --format="value(binding)"
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:tf-serviceaccount@$project_id.iam.gserviceaccount.com --role roles/compute.admin --format="value(binding)"
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:tf-serviceaccount@$project_id.iam.gserviceaccount.com --role roles/compute.instanceAdmin.v1 --format="value(binding)"
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:tf-serviceaccount@$project_id.iam.gserviceaccount.com --role roles/compute.networkAdmin --format="value(binding)"
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:tf-serviceaccount@$project_id.iam.gserviceaccount.com --role roles/compute.securityAdmin --format="value(binding)"
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:tf-serviceaccount@$project_id.iam.gserviceaccount.com --role roles/bigquery.admin --format="value(binding)"
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                              End                             ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##       Terraform: Retrieve files and create environment       ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
# The following lines clone a repository from GitHub, change to its directory, initialize the sparse-checkout feature,
# set the sparse-checkout patterns to only include the terraform directory, and then check out that directory and its contents.
git clone --no-checkout https://github.com/brettdavies/de-zoomcamp-capstone
cd de-zoomcamp-capstone
git sparse-checkout init --cone
git sparse-checkout set terraform
git checkout @

# Change working directory to the users home folder
cd ~/

# Set terraform path variable
terraform_path="$HOME/de-zoomcamp-capstone/terraform"

# Set terraform credential path variable
terraform_cred_path="$HOME/.terraform.d/credentials.tfrc.json"

# Check if the ssh public key file exists and is not empty
if [ -s "$terraform_cred_path" ]; then
    # If the file exists and is not empty, do nothing.
    :
else
    terraform -chdir=$terraform_path login
    # follow instructions to create terraform token and paste back into terminal
    #    https://app.terraform.io/app/settings/tokens?source=terraform-login
fi

terraform -chdir=$terraform_path init

terraform -chdir=$terraform_path plan -var "gcp_project=$project_id"

terraform -chdir=$terraform_path apply -var "gcp_project=$project_id" -auto-approve

# terraform -chdir=$terraform_path destroy -auto-approve
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                              End                             ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                         Set Variables                        ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
# Set VM External IP variable
vm_ext_ip_path="$HOME/vm_ext_ip.env"

# Check if the variable is not set
if [ -z "$vm_ext_ip" ]; then
    # Check if the file exists and is not empty
    if [ -s "$vm_ext_ip_path" ]; then
        # If the file exists and isn't empty, write the file to the variable
        export vm_ext_ip=$(cat "$vm_ext_ip_path")
    else
        # If the file doesn't exist or is empty, write the variable to the file
        export vm_ext_ip=$(terraform -chdir=$terraform_path output -raw vm-external-ip)
        echo "$vm_ext_ip" > "$vm_ext_ip_path"
    fi
else
    # If the variable is already set, check if the file exists and is not empty.
    if [ -s "$vm_ext_ip_path" ]; then
        # If the file exists and is not empty, do nothing.
        :
    else
        # If the file doesn't exist or is empty, write the variable to the file
        echo "$vm_ext_ip" > "$vm_ext_ip_path"
    fi
fi

# Use the vm_ext_ip variable in your script as needed
echo "VM External IP: $vm_ext_ip"
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                              End                             ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##        Transfer files to VM at Google Compute Engine         ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
# Copy the local file specified by the $project_id_path variable to the remote vm home directory
scp -i ~/.ssh/"$(whoami)_$project_id" $project_id_path $(whoami)@$vm_ext_ip:~/project_id.env

# Copy the local script_3_gcp_vm.sh file to the remote vm home directory
scp -i ~/.ssh/"$(whoami)_$project_id" script_3_gcp_vm.sh $(whoami)@$vm_ext_ip:~/script_3_gcp_vm.sh



echo -e "About to execute script_3_gcp_vm.sh in a GCP Compute VM\n"

# Use SSH to connect to the VM instance, make the script_3_gcp_vm.sh file executable, and run it
ssh -i ~/.ssh/"$(whoami)_$project_id" $(whoami)@$vm_ext_ip "chmod +x ~/script_3_gcp_vm.sh; ~/script_3_gcp_vm.sh"
# ssh -i ~/.ssh/"$(whoami)_$project_id" $(whoami)@$vm_ext_ip 
