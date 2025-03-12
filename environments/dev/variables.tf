variable "project_id" {
  description = "The ID of the project"
  type        = string
  default     = "cloud-engineer-exam-452814"
}

variable "region" {
  description = "region"
  type        = string
  default     = "asia-southeast1"
}


variable "zones" {
  description = "List of zones"
  type        = list(string)
  default     = ["asia-southeast1-a", "asia-southeast1-b", "asia-southeast1-c"]
}