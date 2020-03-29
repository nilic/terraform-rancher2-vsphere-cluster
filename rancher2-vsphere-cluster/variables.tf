variable "cloud_credential_name" {
  type        = string
  description = "Name of vSphere cloud credential"
}

variable "node_vsphere_template" {
  type        = string
  description = "Global setting for vSphere template from which to create all cluster nodes; either this or `vsphere_template` parameter inside `node_spec` (which overrides it) need to be set"
  default     = null
}

variable "node_datacenter" {
  type        = string
  description = "Global setting for vSphere datacenter in which to create all cluster nodes; either this or `datacenter` parameter inside `node_spec` (which overrides it) need to be set"
  default     = null
}

variable "node_cluster" {
  type        = string
  description = "Global setting for vSphere cluster in which to create all cluster nodes; either this or `cluster` parameter inside `node_spec` (which overrides it) need to be set"
  default     = null
}

variable "node_datastore" {
  type        = string
  description = "Global setting for vSphere datastore in which to create all cluster nodes; either this or `datastore` parameter inside `node_spec` (which overrides it) need to be set"
  default     = null
}

variable "node_resource_pool" {
  type        = string
  description = "Global setting for vSphere resource pool in which to create all cluster nodes; `resource_pool` parameter inside `node_spec` overrides this global setting; if neither are set, nodes will be created in cluster root"
  default     = null
}

variable "node_folder" {
  type        = string
  description = "Global setting for vSphere VM and template folder in which to create all cluster nodes; `folder` parameter inside `node_spec` overrides this global setting; if neither are set, nodes will be created in datacenter root"
  default     = null
}

variable "node_portgroup" {
  type        = string
  description = "Global setting for vSphere portgroup to which to connect all cluster nodes; either this or `portgroup` parameter inside `node_spec` (which overrides it) need to be set"
  default     = null
}

variable "node_template_ssh_user" {
  type        = string
  description = "Global setting for the SSH user for Rancher to connect to all cluster nodes after deployment from template; either this or `template_ssh_user` parameter inside `node_spec` (which overrides it) need to be set"
  default     = null
}

variable "node_template_ssh_password" {
  type        = string
  description = "Global setting for the SSH password for Rancher to connect to all cluster nodes after deployment from template; either this or `template_ssh_password` parameter inside `node_spec` (which overrides it) need to be set"
  default     = null
}

variable "node_template_ssh_user_group" {
  type        = string
  description = "Global setting for the user group to which Rancher will chown the uploaded keys on all cluster nodes; either this or `template_ssh_user_group` parameter inside `node_spec` (which overrides it) need to be set"
  default     = null
}

variable "node_spec" {
  description = "Specification of node templates for each of the node roles. Available roles are `control_plane`, `etcd`, `master` (consolidated `control_plane` and `etcd`), `worker` and `all_in_one` (`control_plane`, `etcd` and `worker` consolidate on one node, used for creating single node clusters). `node_spec` allows for specifying parameters such as vSphere template, datacenter, cluster etc. on a node role basis. If these parameters are set both through `node_spec` and globally through `node_*`, `node_spec` values will have precedence. As a minimum, each node role needs to have the following inputs set in `node_spec`: `num_vcpu` (VM number of vCPUs), `memory_gb` (VM memory in GB) and `disk_gb` (VM disk size in GB) - all other values can be inherited from global variables. Take a look at the `examples` directory for detailed synthax"
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
  description = "Specification of private registries for Docker images. Multiple registries can be specified, take a look at the `examples` directory for synthax. Only the `url` parameter is mandatory. If you set password access to registry, for future Terraform runs have in mind that Rancher API doesn't return registry password, so every Terraform operation will offer to change the cluster resource by adding the registry password field even if you haven't done any changes in your spec"
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

