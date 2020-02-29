output "id" {
  description = "ID of the created cluster"
  value       = rancher2_cluster.cluster.id
}

output "kube_config" {
  description = "kubeconfig of the created cluster"
  value       = rancher2_cluster.cluster.kube_config
}
