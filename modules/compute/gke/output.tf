output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.gke.name
}

output "cluster_endpoint" {
  description = "The private endpoint of the cluster"
  value       = google_container_cluster.gke.private_cluster_config[0].private_endpoint
}

output "cluster_id" {
  description = "The ID of the GKE cluster"
  value       = google_container_cluster.gke.id
}

output "node_pools" {
  description = "List of node pool names"
  value       = [for np in google_container_node_pool.nodes : np.name]
}
