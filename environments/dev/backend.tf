terraform {
  backend "gcs" {
    bucket  = "tfstate-gcs"
    prefix  = "terraform/state"
    credentials = "../../../cloud-engineer-exam.json"
  }
}
