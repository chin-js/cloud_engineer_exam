resource "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  network    = var.network
  subnetwork = var.subnetwork

  enable_intranode_visibility = true
  remove_default_node_pool    = true
  initial_node_count          = 1

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_ipv4_cidr
    services_secondary_range_name = var.services_ipv4_cidr
  }

  deletion_protection = false
}

resource "google_container_node_pool" "nodes" {
  for_each = { for idx, pool in var.node_pools : pool.name => pool }

  name       = each.value.name
  cluster    = google_container_cluster.gke.id
  location   = var.region
  node_count = each.value.node_count

  autoscaling {
    min_node_count = each.value.min_count
    max_node_count = each.value.max_count
  }

  node_config {
    machine_type = each.value.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
