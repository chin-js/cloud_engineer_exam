output "instance_name" {
  description = "The name of the VM instance"
  value       = google_compute_instance.vm.name
}

output "instance_self_link" {
  description = "Self-link of the VM instance"
  value       = google_compute_instance.vm.self_link
}

output "instance_ip" {
  description = "Internal IP address of the instance"
  value       = google_compute_instance.vm.network_interface[0].network_ip
}

output "public_ip" {
  description = "External IP address (if assigned)"
  value       = try(google_compute_instance.vm.network_interface[0].access_config[0].nat_ip, null)
}
