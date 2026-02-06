############################
# Service Account (CI/CD)
############################
resource "google_service_account" "cicd" {
  account_id   = "cicd-deployer"
  display_name = "CI/CD Deployer"
}

############################
# IAM - Least Privilege
############################
resource "google_project_iam_member" "artifact_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.cicd.email}"
}

resource "google_project_iam_member" "container_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.cicd.email}"
}

############################
# Artifact Registry
############################
resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = var.artifact_repo_name
  format        = "DOCKER"
  description   = "Docker images for DevOps challenge"

  labels = {
    env = "devops-challenge"
    app = "hello-ms"
  }
}

############################
# GKE Cluster (Hardened)
############################
resource "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  networking_mode = "VPC_NATIVE"
  deletion_protection = false

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  enable_shielded_nodes = true

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

############################
# GKE Node Pool (Secure)
############################
resource "google_container_node_pool" "primary_nodes" {
  name     = "${var.cluster_name}-np"
  cluster = google_container_cluster.gke.name
  location = var.zone

  node_count = var.node_count

  node_config {
    machine_type = var.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env  = "devops-challenge"
      app  = "hello-ms"
      team = "devops"
    }
  }
}
