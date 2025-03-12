variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The region where Cloud NAT should be deployed."
  type        = string
}

variable "network" {
  description = "The VPC network name where Cloud NAT will be enabled."
  type        = string
}

variable "name" {
  description = "A name prefix for Cloud Router and Cloud NAT."
  type        = string
}

variable "nat_ip_allocate_option" {
  description = "Method of NAT IP allocation (AUTO_ONLY or MANUAL_ONLY)."
  type        = string
  default     = "AUTO_ONLY"
}

variable "source_subnetwork_ip_ranges_to_nat" {
  description = "Specifies which IP ranges in the subnet should be NATed."
  type        = string
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "enable_logging" {
  description = "Enable logging for NAT traffic."
  type        = bool
  default     = true
}

variable "logging_filter" {
  description = "The logging filter: 'ALL', 'ERRORS_ONLY', or 'TRANSLATIONS_ONLY'."
  type        = string
  default     = "ERRORS_ONLY"
}

variable "subnetworks" {
  description = "List of subnetworks to be NATed (optional)."
  type = list(object({
    name                    = string
    source_ip_ranges_to_nat = list(string)
  }))
  default = []
}
