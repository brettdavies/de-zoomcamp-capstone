##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     GCP Provider - Variables  ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     Change as Required        ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

variable "gcp_auth_file" {
  type        = string
  description = "GCP authentication file"
  sensitive   = true
}

variable "gcp_project" {
  description = "Your GCP Project ID"
  type = string
  default = "my project"
}

variable "gcp_region" {
  description = "Region for GCP resources. Choose as per your location: https://cloud.google.com/about/locations"
  type = string
  default = "us-west1"
}

variable "gcp_zone" {
  description = "Zone for GCP resources. Choose as per your location: https://cloud.google.com/about/locations"
  type = string
  default = "us-west1-a"
} 
