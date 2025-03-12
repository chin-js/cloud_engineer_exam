variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "service_account_name" {
  description = "The name of the service account"
  type        = string
}

variable "service_account_display_name" {
  description = "The display name of the service account"
  type        = string
  default     = ""
}

variable "roles" {
  description = "List of IAM roles to assign to the service account"
  type        = list(string)
  default     = []
}