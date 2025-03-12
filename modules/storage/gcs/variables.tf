variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "bucket_name" {
  description = "The name of the GCS bucket."
  type        = string
}

variable "location" {
  description = "The location of the GCS bucket."
  type        = string
  default     = "US"
}

variable "storage_class" {
  description = "The storage class of the bucket (STANDARD, NEARLINE, COLDLINE, ARCHIVE)."
  type        = string
  default     = "STANDARD"
}

variable "force_destroy" {
  description = "If true, allows the bucket to be deleted even if it contains objects."
  type        = bool
  default     = false
}

variable "uniform_bucket_level_access" {
  description = "Enables uniform bucket-level access to GCS."
  type        = bool
  default     = true
}

variable "versioning" {
  description = "Enable versioning for the bucket."
  type        = bool
  default     = false
}

variable "lifecycle_delete_age_days" {
  description = "Number of days before objects in the bucket are deleted."
  type        = number
  default     = 30
}
