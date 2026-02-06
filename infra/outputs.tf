output "cluster_name" {
  value = google_container_cluster.gke.name
}

output "cluster_location" {
  value = google_container_cluster.gke.location
}

output "artifact_registry" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_repo_name}"
}

output "cicd_service_account" {
  value = google_service_account.cicd.email
}
