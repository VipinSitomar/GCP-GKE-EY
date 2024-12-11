provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "main-cluster" {
  name     = "ey-gke-cluster"
  location = var.region

  remove_default_node_pool = true

  initial_node_count       = 1
  cluster_autoscaling {
    enabled = true
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

    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  management {
    auto_repair = true
    auto_upgrade = true
  }
}


output "kubeconfig" {
  value = google_container_cluster.main-cluster.kubeconfig_raw
}

output "cluster_name" {
  value = google_container_cluster.main-cluster.name
}
