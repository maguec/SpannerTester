resource "google_spanner_instance" "spanner" {
  name                         = "spanner-${random_id.suffix.hex}"
  project                      = var.gcp_project_id
  config                       = "regional-${var.gcp_region}"
  display_name                 = "Test Spanner Instance"
  edition                      = "ENTERPRISE"
  default_backup_schedule_type = "NONE"
  processing_units             = var.spanner_processing_units
  labels = {
    "name" = "spanner-${random_id.suffix.hex}"
  }
}

resource "google_spanner_database" "spanner" {
  instance          = google_spanner_instance.spanner.name
  deletion_protection = false
  name              = var.spanner_database_name
  project           = var.gcp_project_id
  database_dialect  = "GOOGLE_STANDARD_SQL"
}
