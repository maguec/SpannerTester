variable "gcp_project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "gcp_region" {
  type        = string
  default     = "us-west1"
  description = "GCP Region"
}

variable "spanner_processing_units" {
  default     = 100
  description = "Spanner Processing Units"
}

variable "spanner_database_name" {
  type        = string
  default     = "testdb"
  description = "Name of the Spanner Database"
}
