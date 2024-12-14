terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  credentials = file("key.json")
}


resource "google_container_cluster" "main-cluster" {
  name     = var.cluster_name
  deletion_protection = false
  location = var.region
  
  remove_default_node_pool = true

  initial_node_count       = 1
  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum = "0"
      maximum = "10"
    }
    resource_limits {
      resource_type = "memory"
      minimum = "15"
      maximum = "30"
    }
  }

}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  project = var.project_id
  name       = "ey-node-pool"
  location   = var.region
  cluster    = google_container_cluster.main-cluster.name
  node_count = 2

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    disk_size_gb = "20"
    disk_type = "pd-balanced"
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  autoscaling {
      min_node_count = 0
      max_node_count = 10
    }

  management {
    auto_repair = true
    auto_upgrade = true
  }
}


output "cluster_name" {
  value = google_container_cluster.main-cluster.name
}
