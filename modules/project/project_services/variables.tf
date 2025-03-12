variable "project_id" {
  description = "The GCP project ID where the APIs should be enabled."
  type        = string
}

variable "apis" {
  description = "List of APIs to enable."
  type        = list(string)
}
