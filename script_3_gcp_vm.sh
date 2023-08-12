#!/bin/bash

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##        These commands are run inside a GCP Compute VM        ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

echo -e "\nExecuting script_3_gcp_vm.sh in a GCP Compute VM"

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
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                              End                             ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##        Install Anaconda, required modules and packages       ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
# Download the specified version of Anaconda and then install it
wget -nv https://repo.anaconda.com/archive/Anaconda3-2023.07-0-Linux-x86_64.sh 
bash Anaconda3-2023.07-0-Linux-x86_64.sh
# PRESS: ENTER to view the license terms
# TYPE: yes to accept the license terms
# PRESS: ENTER to accept default location
# TYPE: yes to run conda init

# Add Anaconda's bin directory to the beginning of the PATH environment variable
export PATH="$HOME/anaconda3/bin:$PATH"

# Install the wget module into Anaconda
pip3 install wget

# Check if the file exists and is not empty
if [ -s "Anaconda3-2023.07-0-Linux-x86_64.sh" ]; then
    # Delete the file
    rm -r Anaconda3-2023.07-0-Linux-x86_64.sh
else
    # If the file doesm't exist, do nothing.
    :
fi

# Check if the $USER has already been added to the 
if ! sudo grep -q "$USER ALL=(ALL:ALL) NOPASSWD: /usr/bin/apt-get" /etc/sudoers; then
    # Add the $USER
    echo "$USER ALL=(ALL:ALL) NOPASSWD: /usr/bin/apt-get" | sudo tee -a /etc/sudoers
else
    # If the $USER already exists, do nothing.
    :
fi

# Update the package lists for upgrades and new package installations
sudo apt-get update
# Install the git package quietly without displaying progress
sudo apt-get -qq install git
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                              End                             ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                  Prefect: Install and login                  ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
# Install the prefect module into Anaconda
pip3 install prefect -U

# Set Prefect API Key path variable
prefect_api_key_path="$HOME/prefect_api_key.env"

# Check if the variable is not set
if [ -z "$prefect_api_key" ]; then
    # Check if the file exists and is not empty
    if [ -s "$prefect_api_key_path" ]; then
        # If the file exists and isn't empty, write the file to the variable
        export prefect_api_key=$(cat "$prefect_api_key_path")
    else
        # If the file doesn't exist or is empty, write the variable to the file
        echo "Please enter your Prefect API Key (https://app.prefect.cloud/my/api-keys):"
        read prefect_api_key
        echo "$prefect_api_key" > "$prefect_api_key_path"
    fi
else
    # If the variable is already set, check if the file exists and is not empty.
    if [ -s "$prefect_api_key_path" ]; then
        # If the file exists and is not empty, do nothing.
        :
    else
        # If the file doesn't exist or is empty, write the variable to the file
        echo "$prefect_api_key" > "$prefect_api_key_path"
    fi
fi

# Login to Prefect Cloud
prefect cloud login -key $prefect_api_key
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                              End                             ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

# The following line clone a repository from GitHub
git clone https://github.com/brettdavies/de-zoomcamp-capstone.git -q

# Install the required modules into Anaconda
pip3 install -r de-zoomcamp-capstone/requirements.txt
