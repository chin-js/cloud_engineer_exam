variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the cluster"
  type        = string
}

variable "network" {
  description = "VPC network name"
  type        = string
}

variable "subnetwork" {
  description = "Subnet name for the cluster"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "master_ipv4_cidr" {
  description = "CIDR range for the master nodes"
  type        = string
}

variable "node_pools" {
  description = "Node pool configurations"
  type = list(object({
    name         = string
    machine_type = string
    node_count   = number
    min_count    = number
    max_count    = number
  }))
}

variable "pods_ipv4_cidr" {
  description = "CIDR range for the pods"
  type        = string
}

variable "services_ipv4_cidr" {
  description = "CIDR range for the services"
  type        = string
}
