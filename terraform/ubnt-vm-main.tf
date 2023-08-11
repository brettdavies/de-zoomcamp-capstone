##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     GCP Linux VM - Main       ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     Change as Required        ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

/* App Data Disk --------------------------------------------------------------------- */
resource "google_compute_disk" "app-data" {
  name    = "app-data"
  type    = "pd-standard"
  zone    = "${var.gcp_zone}"
  size    = 20
  labels = {
    vm        = "gcp-cos-vm-01"
    managedby = "terraform"
  }
}

/* VM --------------------------------------------------------------------- */
resource "google_compute_instance" "gcp-ubnt-vm" {
  name         = var.vm_name
  machine_type = var.vm_instance_type
  zone         = var.gcp_zone
  can_ip_forward = "true"
  allow_stopping_for_update = "true"
  tags         = ["ssh","http-server","https-server"]


/* Boot Disk --------------------------------------------------------------------- */
  boot_disk {
      initialize_params {
          image = var.ubnt_2204
      }
  }

/* App Data Disk --------------------------------------------------------------------- */
  attached_disk {
    source     = google_compute_disk.app-data.self_link
    device_name =  google_compute_disk.app-data.name
  }

/* Startup Script --------------------------------------------------------------------- */
  metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  }

  # metadata_startup_script = "${file("../startup/startup.sh")}"

  /* Network --------------------------------------------------------------------- */
  network_interface {
    network       = google_compute_network.vpc.name
    subnetwork    = google_compute_subnetwork.network_subnet.name
    access_config {
    }
  }

  /* Options --------------------------------------------------------------------- */
  scheduling {
    automatic_restart = true
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }
}
