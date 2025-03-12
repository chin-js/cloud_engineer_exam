resource "google_dns_managed_zone" "private_googleapis" {
  name        = var.googleapis_zone_name
  dns_name    = "googleapis.com."
  project     = var.project_id
  description = "Private DNS zone for Google APIs"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = "projects/${var.project_id}/global/networks/${var.network}"
    }
  }
}

resource "google_dns_record_set" "googleapis" {
  name         = "*.googleapis.com."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.private_googleapis.name

  rrdatas = var.private_googleapis_ips
}

resource "google_dns_managed_zone" "private_restricted_googleapis" {
  name        = var.restricted_googleapis_zone_name
  dns_name    = "restricted.googleapis.com."
  project     = var.project_id
  description = "Private DNS zone for Restricted Google APIs"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = "projects/${var.project_id}/global/networks/${var.network}"
    }
  }
}

resource "google_dns_record_set" "restricted_googleapis" {
  name         = "*.restricted.googleapis.com."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.private_restricted_googleapis.name

  rrdatas = var.restricted_googleapis_ips
}


resource "google_dns_managed_zone" "private_gcr_io" {
  name        = var.gcr_io_zone_name
  dns_name    = "gcr.io."
  project     = var.project_id
  description = "Private DNS zone for gcr.io to enable Private Google Access"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = "projects/${var.project_id}/global/networks/${var.network}"
    }
  }
}

resource "google_dns_record_set" "gcr_a_record" {
  name         = "gcr.io."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.private_gcr_io.name

  rrdatas = var.private_googleapis_ips
}

resource "google_dns_record_set" "gcr_cname_record" {
  name         = "*.gcr.io."
  type         = "CNAME"
  ttl          = 300
  managed_zone = google_dns_managed_zone.private_gcr_io.name

  rrdatas = ["gcr.io."]
}
