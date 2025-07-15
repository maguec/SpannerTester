resource "google_service_account" "spanner_service_account" {
  project      = var.gcp_project_id
  account_id   = "account-${random_id.suffix.hex}"
  display_name = "Service Account ${random_id.suffix.hex}"
}

resource "google_project_iam_binding" "project" {
  project = var.gcp_project_id
  role    = "roles/spanner.admin"

  members = [
    "serviceAccount:${google_service_account.spanner_service_account.email}"
  ]
}
