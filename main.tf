provider "google" {
  project = var.project_id
  region  = var.region
  credentials = file("key.json")
}

resource "google_project_service" "required_services" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ])
  service = each.key
  project = var.project_id
}

resource "google_container_cluster" "main-cluster" {
  name     = "main-gke-cluster1"
  location = var.region

  remove_default_node_pool = true

  initial_node_count       = 1
  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum = "4"
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
    disk_size_gb = "100"
    disk_type = "pd-balanced"

    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  management {
    auto_repair = true
    auto_upgrade = true
  }
}


output "cluster_name" {
  value = google_container_cluster.main-cluster.name
}
