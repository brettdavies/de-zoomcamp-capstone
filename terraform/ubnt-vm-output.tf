##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     GCP Linux VM - Output     ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     Change as Required        ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

output "vm-name" {
  value = google_compute_instance.gcp-ubnt-vm.name
}

output "vm-external-ip" {
  value = google_compute_instance.gcp-ubnt-vm.network_interface.0.access_config.0.nat_ip
}

output "vm-internal-ip" {
  value = google_compute_instance.gcp-ubnt-vm.network_interface.0.network_ip
}