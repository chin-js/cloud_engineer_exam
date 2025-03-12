output "router_name" {
  description = "Name of the created Cloud Router."
  value       = google_compute_router.router.name
}

output "nat_name" {
  description = "Name of the created Cloud NAT."
  value       = google_compute_router_nat.nat.name
}
