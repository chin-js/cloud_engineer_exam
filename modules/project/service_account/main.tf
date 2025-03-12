resource "google_service_account" "default" {
  project      = var.project_id
  account_id   = var.service_account_name
  display_name = var.service_account_display_name
}

resource "google_project_iam_member" "default" {
  count   = length(var.roles)
  project = var.project_id
  role    = var.roles[count.index]
  member  = "serviceAccount:${google_service_account.default.email}"
}