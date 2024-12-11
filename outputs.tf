output "cluster_name" {
  value       = google_container_cluster.main-cluster.name
  description = "Name of the GKE cluster"
}
