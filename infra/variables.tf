variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "devops-cluster"
}

variable "node_count" {
  description = "Number of GKE nodes"
  type        = number
  default     = 2
}

variable "machine_type" {
  description = "GKE node machine type"
  type        = string
  default     = "e2-medium"
}

variable "artifact_repo_name" {
  description = "Artifact Registry repository name"
  type        = string
  default     = "devops-repo"
}
