resource "google_compute_router" "router" {
  name    = "${var.name}-router"
  region  = var.region
  network = var.network

  project = var.project_id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.name}-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  project                            = var.project_id
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat

  log_config {
    enable = var.enable_logging
    filter = var.logging_filter
  }

  dynamic "subnetwork" {
    for_each = var.subnetworks
    content {
      name                    = subnetwork.value["name"]
      source_ip_ranges_to_nat = subnetwork.value["source_ip_ranges_to_nat"]
    }
  }
}
