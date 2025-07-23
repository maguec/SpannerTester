resource "google_compute_instance" "vm" {
  project             = var.gcp_project_id
  name                = "vm-${random_id.suffix.hex}"
  machine_type        = "n1-standard-8"
  zone                = "${var.gcp_region}-a"
  tags                = ["ssh-access-${random_id.suffix.hex}"]
  deletion_protection = false

  metadata_startup_script = templatefile(
    "startup_script.sh",
    {
      projectid : var.gcp_project_id,
      region : var.gcp_region,
      spannerinstance : google_spanner_instance.spanner.name,
      spannerdatabase : google_spanner_database.spanner.name
    },
  )


  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
    }
  }

  network_interface {
    network            = google_compute_network.vpc.name
    subnetwork         = google_compute_subnetwork.spanner-subnet.name
    subnetwork_project = var.gcp_project_id
    access_config {
      # This will auto generated an external IP
    }
  }

  shielded_instance_config {
    enable_secure_boot = true
  }

  service_account {
    email  = google_service_account.spanner_service_account.email
    scopes = ["cloud-platform"]
  }

  # Stop updating if the boot disk changes
  lifecycle {
    ignore_changes = [boot_disk]
  }
}
