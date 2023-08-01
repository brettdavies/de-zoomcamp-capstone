##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
## Network Firewall Rules - Main ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     Change as Required        ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

# Update all instances of IDENTIFIER in the name fields below with something unique to you like VM name or your initials.

# Allow http
resource "google_compute_firewall" "allow-http" {
  name    = "decap-fw-allow-http"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
}

# allow https
resource "google_compute_firewall" "allow-https" {
  name    = "decap-fw-allow-https"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["https-server"]
}

# allow ssh
resource "google_compute_firewall" "allow-ssh" {
  name    = "decap-fw-allow-ssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ssh"]
}

# allow prefect
resource "google_compute_firewall" "allow-prefect" {
  name    = "decap-fw-allow-prefect"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["4200","8080"]
  }

  source_ranges = ["0.0.0.0/0"]
}