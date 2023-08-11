##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     Terraform - Variables     ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     Change as Required        ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

# Please update all the info below with your own project ID, region you want this hosted in, network CIDR and instance type.

# GCP Settings
gcp_region    = "us-west1" # this default is a region where free (as in beer) resources are available as of the time of this commit
gcp_zone      = "us-west1-a" # this default is a zone where free (as in beer) resources are available as of the time of this commit
gcp_auth_file = "~/auth/google-key.json"

# GCP Netwok
network-subnet-cidr = "10.0.10.0/24"

# Linux VM
vm_instance_type = "e2-micro" # this default is an instance type that is free (as in beer) as of the time of this commit
vm_name = "[redacted]" # this is where you name your vm
email = "[redacted]" # this should match the service account we set earlier
