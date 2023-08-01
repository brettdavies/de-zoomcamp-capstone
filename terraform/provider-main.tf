###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     GCP Provider - Main       ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     Change as Required        ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

# Define Terraform provider
terraform {
  required_version = "~> 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}

provider "google" {
  credentials = file(var.gcp_auth_file)
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}
