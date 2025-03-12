variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "network" {
  description = "The VPC network name where Private DNS will be applied."
  type        = string
}

variable "googleapis_zone_name" {
  description = "The name of the private DNS zone for googleapis.com."
  type        = string
  default     = "private-googleapis"
}

variable "restricted_googleapis_zone_name" {
  description = "The name of the private DNS zone for restricted.googleapis.com."
  type        = string
  default     = "private-restricted-googleapis"
}

variable "private_googleapis_ips" {
  description = "The list of internal IPs for googleapis.com."
  type        = list(string)
  default     = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
}

variable "restricted_googleapis_ips" {
  description = "The list of internal IPs for restricted.googleapis.com."
  type        = list(string)
  default     = ["199.36.153.4", "199.36.153.5", "199.36.153.6", "199.36.153.7"]
}

variable "gcr_io_zone_name" {
  description = "The name of the private DNS zone for gcr.io."
  type        = string
  default     = "private-gcr-io"
}
