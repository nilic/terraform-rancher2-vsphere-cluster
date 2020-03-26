terraform {
  required_providers {
    rancher2 = ">= 1.7.2"
  }
}

data "rancher2_cloud_credential" "cloud_credential" {
  name = var.cloud_credential_name
}

resource "rancher2_node_template" "node_template" {
  for_each = var.node_specs

  name                = "${var.cluster_name}-${each.key}-template"
  description         = "Node template for vSphere K8s cluster ${var.cluster_name} - ${replace(each.key, "_", " ")} node"
  cloud_credential_id = data.rancher2_cloud_credential.cloud_credential.id
  vsphere_config {
    creation_type             = "template"
    clone_from                = "/${each.value.datacenter}/vm/${each.value.vsphere_template}"
    cpu_count                 = each.value.num_vcpu
    memory_size               = each.value.memory_gb * 1024
    disk_size                 = each.value.disk_gb * 1024
    datacenter                = "/${each.value.datacenter}"
    datastore                 = "/${each.value.datacenter}/datastore/${each.value.datastore}"
    pool                      = "/${each.value.datacenter}/host/${each.value.cluster}/Resources/${each.value.resource_pool}"
    folder                    = "/${each.value.datacenter}/vm/${each.value.folder}"
    network                   = ["/${each.value.datacenter}/network/${each.value.portgroup}"]
    ssh_user                  = each.value.template_ssh_user
    ssh_password              = each.value.template_ssh_password
    ssh_user_group            = each.value.template_ssh_user_group
    vapp_ip_allocation_policy = "fixedAllocated"
    vapp_ip_protocol          = "IPv4"
    vapp_transport            = "com.vmware.guestInfo"
    vapp_property = [
      "guestinfo.dns.servers=$${dns:${each.value.portgroup}}",
      "guestinfo.dns.domains=$${searchPath:${each.value.portgroup}}",
      "guestinfo.interface.0.ip.0.address=ip:${each.value.portgroup}",
      "guestinfo.interface.0.ip.0.netmask=$${netmask:${each.value.portgroup}}",
      "guestinfo.interface.0.route.0.gateway=$${gateway:${each.value.portgroup}}"
    ]
    cloud_config = "#cloud-config"
  }
}

resource "rancher2_cluster" "cluster" {
  name                      = var.cluster_name
  description               = var.cluster_description
  enable_cluster_monitoring = var.enable_monitoring
  enable_cluster_alerting   = var.enable_alerting
  enable_cluster_istio      = var.enable_istio
  rke_config {
    network {
      plugin = var.k8s_network_plugin
    }
  }
}

resource "rancher2_node_pool" "master_nodes" {
  count = var.master_node_quantity != null ? 1 : 0

  cluster_id       = rancher2_cluster.cluster.id
  name             = var.master_node_pool_name
  hostname_prefix  = var.master_node_prefix
  node_template_id = rancher2_node_template.node_template["master"].id
  quantity         = var.master_node_quantity
  control_plane    = true
  etcd             = true
  worker           = false
}

resource "rancher2_node_pool" "control_plane_nodes" {
  count = var.control_plane_node_quantity != null ? 1 : 0

  cluster_id       = rancher2_cluster.cluster.id
  name             = var.control_plane_node_pool_name
  hostname_prefix  = var.control_plane_node_prefix
  node_template_id = rancher2_node_template.node_template["control_plane"].id
  quantity         = var.control_plane_node_quantity
  control_plane    = true
  etcd             = false
  worker           = false
}

resource "rancher2_node_pool" "etcd_nodes" {
  count = var.etcd_node_quantity != null ? 1 : 0

  cluster_id       = rancher2_cluster.cluster.id
  name             = var.etcd_node_pool_name
  hostname_prefix  = var.etcd_node_prefix
  node_template_id = rancher2_node_template.node_template["etcd"].id
  quantity         = var.etcd_node_quantity
  control_plane    = false
  etcd             = true
  worker           = false
}

resource "rancher2_node_pool" "worker_nodes" {
  count = var.worker_node_quantity != null ? 1 : 0

  cluster_id       = rancher2_cluster.cluster.id
  name             = var.worker_node_pool_name
  hostname_prefix  = var.worker_node_prefix
  node_template_id = rancher2_node_template.node_template["worker"].id
  quantity         = var.worker_node_quantity
  control_plane    = false
  etcd             = false
  worker           = true
}

resource "rancher2_node_pool" "all_in_one_node" {
  count = var.single_node_cluster ? 1 : 0

  cluster_id       = rancher2_cluster.cluster.id
  name             = var.all_in_one_node_pool_name
  hostname_prefix  = var.all_in_one_node_prefix
  node_template_id = rancher2_node_template.node_template["all_in_one"].id
  quantity         = 1
  control_plane    = true
  etcd             = true
  worker           = true
}
