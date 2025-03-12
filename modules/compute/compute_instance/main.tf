# resource "google_compute_disk" "disk" {
#   name = "${var.instance_name}-data-disk"
#   size = var.disk_size_data
#   zone = var.zone
#   type = var.disk_type_data
# }

resource "google_compute_instance" "vm" {
  name         = var.instance_name
  project      = var.project_id
  zone         = var.zone
  machine_type = var.machine_type
  allow_stopping_for_update = var.allow_stopping_for_update
  tags = var.tags

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size_os
      type  = var.disk_type_os
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    network_ip = var.network_ip
    # access_config {}
  }

  metadata = var.metadata

  service_account {
    email  = var.service_account_email
    scopes = var.scopes
  }
  # depends_on = [ google_compute_disk.disk ]
}

# resource "google_compute_attached_disk" "attached_disk" {
#   disk     = google_compute_disk.disk.id
#   instance = google_compute_instance.vm.id
#   depends_on = [ google_compute_disk.disk,google_compute_instance.vm ]
# }

