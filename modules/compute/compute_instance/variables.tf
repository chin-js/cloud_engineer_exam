variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "instance_name" {
  description = "Name of the VM instance"
  type        = string
}

variable "zone" {
  description = "GCP Zone where the instance will be created"
  type        = string
}

variable "machine_type" {
  description = "Compute instance machine type"
  type        = string
  default     = "e2-medium"
}

variable "image" {
  description = "OS image to use for the boot disk"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "disk_size_os" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 20
}

variable "disk_type_os" {
  description = "Type of os disk (pd-standard, pd-ssd, etc.)"
  type        = string
  default     = "pd-standard"
}

# variable "disk_size_data" {
#   description = "Size of the data disk in GB"
#   type        = number
#   default     = 0
# }

# variable "disk_type_data" {
#   description = "Type of data disk (pd-standard, pd-ssd, etc.)"
#   type        = string
#   default     = "pd-standard"
# }

variable "network" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnetwork" {
  description = "Name of the subnetwork"
  type        = string
}

variable "tags" {
  description = "List of network tags"
  type        = list(string)
  default     = []
}

variable "metadata" {
  description = "Metadata key-value pairs for the VM"
  type        = map(string)
  default     = {}
}

variable "service_account_email" {
  description = "Service account email"
  type        = string
  default     = "default"
}

variable "scopes" {
  description = "Scopes assigned to the service account"
  type        = list(string)
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "allow_stopping_for_update" {
  description = "allows Terraform to stop the instance to update its properties"
  type = bool
  default = false
}

variable "network_ip" {
  description = "value"
  type = string
  default = null
}
