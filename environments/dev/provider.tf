provider "google" {
  project = var.project_id
  region  = var.region
  credentials = "../../../cloud-engineer-exam.json"
}