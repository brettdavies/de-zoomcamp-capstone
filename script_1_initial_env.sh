#!/bin/bash

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##       These commands are run in your local environment       ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

echo "Executing script_1_initial_env.sh in local environment"


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                         Set Variables                        ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
#Set Project ID Variable
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


#Set GCP Billing ID Variable
export gcpbilling_id="014CB7-5928EE-3EED2F"
gcpbilling_id_path="$HOME/gcpbilling_id.env"

# Check if the variable is not set
if [ -z "$gcpbilling_id" ]; then
    # Check if the file exists and is not empty
    if [ -s "$gcpbilling_id_path" ]; then
        # If the file exists and isn't empty, write the file to the variable
        export gcpbilling_id=$(cat "$gcpbilling_id_path")
    else
        # If the file doesn't exist or is empty, write the variable to the file
        echo "Please enter the value for the gcpbilling_id variable:"
        read gcpbilling_id
        echo "$gcpbilling_id" > "$gcpbilling_id_path"
    fi
else
    # If the variable is already set, check if the file exists and is not empty.
    if [ -s "$gcpbilling_id_path" ]; then
        # If the file exists and is not empty, do nothing.
        :
    else
        # If the file doesn't exist or is empty, write the variable to the file
        echo "$gcpbilling_id" > "$gcpbilling_id_path"
    fi
fi

# Use the gcpbilling_id variable in your script as needed
echo "GCP Billing ID: $gcpbilling_id"

# Query for the ssh key in the existing ssh keys in the GCP Project
output=$(gcloud auth list --format="value(account)")

# If there isn't an authorized account, then run login process
if [ -z "$output" ]; then
    gcloud auth login --launch-browser --brief
    # [[follow login instructions]]
else
    # If there as an authenicated account, do nothing.
    :
fi
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                              End                             ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                Configure Google Cloud Services               ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
# Disable usage reporting for gcloud commands
gcloud config set disable_usage_reporting true

# Install the beta version of gcloud components
gcloud components install beta

# Create a new Google Cloud project with the specified project ID
gcloud projects create $project_id

# Set the current gcloud configuration to use the specified project ID
gcloud config set project $project_id

# Enable the Cloud Billing API for the current project
gcloud services enable cloudbilling.googleapis.com

# Link the current project to a billing account using the beta version of the gcloud command
gcloud beta billing projects link $project_id --billing-account=$gcpbilling_id

# Enable several APIs for the current project, including Compute Engine, IAM, IAM Credentials, and Cloud Resource Manager
gcloud services enable compute.googleapis.com iam.googleapis.com iamcredentials.googleapis.com cloudresourcemanager.googleapis.com
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                              End                             ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##             Transfer files to Google Cloud Shell             ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
# Copy the local file specified by the $project_id_path variable to the Google Cloud Shell home directory
gcloud cloud-shell scp localhost:$project_id_path cloudshell:~/project_id.env

# Copy the local script_2_gcp_shell.sh file to the Google Cloud Shell home directory
gcloud cloud-shell scp localhost:./script_2_gcp_shell.sh cloudshell:~/script_2_gcp_shell.sh

# Copy the local script_3_gcp_vm.sh file to the Google Cloud Shell home directory
gcloud cloud-shell scp localhost:./script_3_gcp_vm.sh cloudshell:~/script_3_gcp_vm.sh
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                              End                             ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##


echo -e "About to execute script_2_gcp_shell.sh in a Google Cloud Shell session\n"

# Authorize the current session and run the script_2_gcp_shell.sh file on the Google Cloud Shell instance
gcloud cloud-shell ssh --authorize-session --command "chmod +x ~/script_2_gcp_shell.sh; ~/script_2_gcp_shell.sh"
# gcloud cloud-shell ssh --authorize-session
