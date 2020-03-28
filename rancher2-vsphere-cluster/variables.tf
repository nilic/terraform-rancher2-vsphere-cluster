variable "cloud_credential_name" {
  type        = string
  description = "Name of vSphere cloud credential"
}

variable "node_spec" {
  description = "Specification of node templates, take a look at the `examples` directory for synthax"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "cluster_description" {
  type        = string
  description = "Cluster description"
}

variable "enable_monitoring" {
  type        = bool
  description = "Whether to enable cluster monitoring"
  default     = true
}

variable "enable_alerting" {
  type        = bool
  description = "Whether to enable cluster alerting"
  default     = false
}

variable "enable_istio" {
  type        = bool
  description = "Whether to enable Istio for the cluster"
  default     = false
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to deploy"
  default     = null
}

variable "kubernetes_network_plugin" {
  type        = string
  description = "Kubernetes network plugin to use, one of `canal` (default), `flannel`, `calico`, `weave`"
  default     = "canal"
}

variable "private_registries_spec" {
  description = "Specification of private registries for Docker images. Take a look at the `examples` directory for synthax"
  default     = {}
}

variable "cloud_provider_spec" {
  description = "Specification of vSphere cloud provider, which is necessary to allow dynamic provisioning of volumes. Take a look at the `examples` directory for synthax and Rancher vSphere Cloud Provider documentation for explanation of parameters"
  default     = {}
}

variable "master_node_pool_name" {
  type        = string
  description = "Name of the master (consolidated control plane and etcd) node pool"
  default     = "master"
}

variable "master_node_prefix" {
  type        = string
  description = "Prefix for nodes created in master (consolidated control plane and etcd) node pool"
  default     = "master-"
}

variable "master_node_quantity" {
  type        = number
  description = "Number of nodes in master (consolidated control plane and etcd) node pool"
  default     = null
}

variable "etcd_node_pool_name" {
  type        = string
  description = "Name of the etcd node pool"
  default     = "etcd"
}

variable "etcd_node_prefix" {
  type        = string
  description = "Prefix for nodes created in etcd node pool"
  default     = "etcd-"
}

variable "etcd_node_quantity" {
  type        = number
  description = "Number of nodes in etcd node pool"
  default     = null
}

variable "control_plane_node_pool_name" {
  type        = string
  description = "Name of the control plane node pool"
  default     = "control-plane"
}

variable "control_plane_node_prefix" {
  type        = string
  description = "Prefix for nodes created in control plane node pool"
  default     = "control-plane-"
}

variable "control_plane_node_quantity" {
  type        = number
  description = "Number of nodes in control plane node pool"
  default     = null
}

variable "worker_node_pool_name" {
  type        = string
  description = "Name of the worker node pool"
  default     = "worker"
}

variable "worker_node_prefix" {
  type        = string
  description = "Prefix for nodes created in worker node pool"
  default     = "worker-"
}

variable "worker_node_quantity" {
  type        = number
  description = "Number of nodes in worker node pool"
  default     = null
}

variable "single_node_cluster" {
  type        = bool
  description = "Whether to create a single node cluster with all roles consolidated on one node"
  default     = false
}

variable "all_in_one_node_pool_name" {
  type        = string
  description = "Name of the all-in-one node pool"
  default     = "all-in-one"
}

variable "all_in_one_node_prefix" {
  type        = string
  description = "Prefix for node created in the all-in-one node pool"
  default     = "all-in-one-"
}

