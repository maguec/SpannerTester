output "vm_ssh_command" {
  value = "gcloud compute ssh --zone ${var.gcp_region}-a vm-${random_id.suffix.hex} --project ${var.gcp_project_id}"
}
