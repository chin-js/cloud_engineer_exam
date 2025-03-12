output "private_googleapis_zone_name" {
  description = "The name of the Private DNS Zone for googleapis.com."
  value       = google_dns_managed_zone.private_googleapis.name
}

output "private_restricted_googleapis_zone_name" {
  description = "The name of the Private DNS Zone for restricted.googleapis.com."
  value       = google_dns_managed_zone.private_restricted_googleapis.name
}

output "private_gcr_io_zone_name" {
  description = "The name of the Private DNS Zone for gcr.io."
  value       = google_dns_managed_zone.private_gcr_io.name
}
