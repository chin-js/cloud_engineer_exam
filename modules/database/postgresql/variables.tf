variable "instance_name" {
  type        = string
  description = "Name of Cloud SQL instance"
}

variable "database_version" {
  type        = string
  default     = "POSTGRES_15"
  description = "PostgreSQL database version"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "tier" {
  type        = string
  default     = "db-f1-micro"
  description = "Machine type for instance"
}

variable "availability_type" {
  type        = string
  default     = "ZONAL"
  description = "Availability type (REGIONAL or ZONAL)"
}

variable "disk_size_gb" {
  type        = number
  default     = 20
  description = "Disk size in GB"
}

variable "disk_type" {
  type        = string
  default     = "PD_SSD"
  description = "Disk type (PD_SSD or PD_HDD)"
}

variable "public_ip_enabled" {
  type        = bool
  default     = false
  description = "Enable public IP"
}

variable "private_network" {
  type        = string
  default     = null
  description = "VPC network for private connectivity"
}

variable "authorized_networks" {
  type        = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "List of networks allowed to connect"
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Prevent instance deletion"
}

variable "authorized_networks_ips" {
  type        = string
  description = "authorized network CIDRs"
  default     = null
}
