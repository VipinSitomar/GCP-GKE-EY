output "cluster_name" {
  value       = google_container_cluster.primary.name
  description = "Name of the GKE cluster"
}