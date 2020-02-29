variable "cloud_credential_name" {
  type        = string
  description = "Name of vSphere cloud credential"
}

variable "node_specs" {
  description = "Specification of node templates"
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

variable "k8s_network_plugin" {
  type        = string
  description = "Which K8s network plugin to use, one of `canal`, `flannel`, `calico`, `weave`"
  default     = "canal"
}

variable "master_node_pool_name" {
  type        = string
  description = "Name of the Master node pool"
  default     = "master"
}

variable "master_node_prefix" {
  type        = string
  description = "Prefix for nodes created in Master node pool"
  default     = "master-"
}

variable "master_node_quantity" {
  type        = number
  description = "Number of nodes in Master node pool"
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

variable "control_node_pool_name" {
  type        = string
  description = "Name of the control plane node pool"
  default     = "control"
}

variable "control_node_prefix" {
  type        = string
  description = "Prefix for nodes created in control plane node pool"
  default     = "control-"
}

variable "control_node_quantity" {
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
