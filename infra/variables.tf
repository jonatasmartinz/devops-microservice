variable "project_id" {
  description = "GCP Project ID (ex: devops-atendas)"
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

# --- Network (VPC/Subnet) ---
variable "network_name" {
  description = "VPC network name"
  type        = string
  default     = "devops-vpc"
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default     = "devops-subnet"
}

variable "subnet_cidr" {
  description = "Primary CIDR for subnet"
  type        = string
  default     = "10.10.0.0/16"
}

variable "pods_secondary_range" {
  description = "Secondary CIDR range for GKE Pods"
  type        = string
  default     = "10.20.0.0/16"
}

variable "services_secondary_range" {
  description = "Secondary CIDR range for GKE Services"
  type        = string
  default     = "10.30.0.0/20"
}
