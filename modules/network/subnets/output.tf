/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "subnets" {
  value       = google_compute_subnetwork.subnetwork
  description = "The created subnet resources"
}

output "subnet_names" {
  description = "List of subnet names"
  value       = [for subnet in google_compute_subnetwork.subnetwork : subnet.name]
}

output "subnet_cidr_ips" {
  description = "cidr"
  value = [for cidr in google_compute_subnetwork.subnetwork : cidr.ip_cidr_range]
}


output "secondary_subnet_cidr_ips" {
  description = "cidr"
  value = [for cidr in google_compute_subnetwork.subnetwork : cidr.secondary_ip_range]
}