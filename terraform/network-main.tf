##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##      Network - Main           ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     Change as Required        ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

# Update IDENTIFIER in the name fields below with something unique to you like VM name or your initials.

# Create VPC
resource "google_compute_network" "vpc" {
  name                    = "decap-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

# Create public subnet
resource "google_compute_subnetwork" "network_subnet" {
  name          = "decap-subnet"
  ip_cidr_range = var.network-subnet-cidr
  network       = google_compute_network.vpc.name
  region        = var.gcp_region
}

# Create network tier
resource "google_compute_project_default_network_tier" "default" {
  network_tier = "STANDARD"
}
