data "rancher2_cloud_credential" "cloud_credential" {
  name = var.cloud_credential_name
}

resource "rancher2_node_template" "node_template" {
  for_each = var.node_spec

  name                = "${var.cluster_name}-${each.key}-template"
  description         = "Node template for vSphere K8s cluster ${var.cluster_name} - ${replace(each.key, "_", " ")} node"
  cloud_credential_id = data.rancher2_cloud_credential.cloud_credential.id
  vsphere_config {
    creation_type             = "template"
    clone_from                = contains(keys(each.value), "vsphere_template") ? (contains(keys(each.value), "datacenter") ? "/${each.value.datacenter}/vm/${each.value.vsphere_template}" : "/${var.node_datacenter}/vm/${each.value.vsphere_template}") : (contains(keys(each.value), "datacenter") ? "/${each.value.datacenter}/vm/${var.node_vsphere_template}" : "/${var.node_datacenter}/vm/${var.node_vsphere_template}")
    cpu_count                 = each.value.num_vcpu
    memory_size               = each.value.memory_gb * 1024
    disk_size                 = each.value.disk_gb * 1024
    datacenter                = contains(keys(each.value), "datacenter") ? "/${each.value.datacenter}" : "/${var.node_datacenter}"
    datastore                 = contains(keys(each.value), "datastore") ? (contains(keys(each.value), "datacenter") ? "/${each.value.datacenter}/datastore/${each.value.datastore}" : "/${var.node_datacenter}/datastore/${each.value.datastore}") : (contains(keys(each.value), "datacenter") ? "/${each.value.datacenter}/datastore/${var.node_datastore}" : "/${var.node_datacenter}/datastore/${var.node_datastore}")
    pool                      = contains(keys(each.value), "resource_pool") ? (contains(keys(each.value), "datacenter") ? (contains(keys(each.value), "cluster") ? "/${each.value.datacenter}/host/${each.value.cluster}/Resources/${each.value.resource_pool}" : "/${each.value.datacenter}/host/${each.value.cluster}/Resources/${var.node_resource_pool}") : (contains(keys(each.value), "cluster") ? "/${var.node_datacenter}/host/${each.value.cluster}/Resources/${each.value.resource_pool}" : "/${var.node_datacenter}/host/${var.node_cluster}/Resources/${each.value.resource_pool}")) : var.node_resource_pool != null ? (contains(keys(each.value), "datacenter") ? (contains(keys(each.value), "cluster") ? "/${each.value.datacenter}/host/${each.value.cluster}/Resources/${var.node_resource_pool}" : "/${each.value.datacenter}/host/${var.node_cluster}/Resources/${var.node_resource_pool}") : (contains(keys(each.value), "cluster") ? "/${var.node_datacenter}/host/${each.value.cluster}/Resources/${var.node_resource_pool}" : "/${var.node_datacenter}/host/${var.node_cluster}/Resources/${var.node_resource_pool}")) : (contains(keys(each.value), "datacenter") ? (contains(keys(each.value), "cluster") ? "/${each.value.datacenter}/host/${each.value.cluster}/Resources" : "/${each.value.datacenter}/host/${var.node_cluster}/Resources") : (contains(keys(each.value), "cluster") ? "/${var.node_datacenter}/host/${each.value.cluster}/Resources" : "/${var.node_datacenter}/host/${var.node_cluster}/Resources"))
    folder                    = contains(keys(each.value), "folder") ? (contains(keys(each.value), "datacenter") ? "/${each.value.datacenter}/vm/${each.value.folder}" : "/${var.node_datacenter}/vm/${each.value.folder}") : var.node_folder != null ? (contains(keys(each.value), "datacenter") ? "/${each.value.datacenter}/vm/${var.node_folder}" : "/${var.node_datacenter}/vm/${var.node_folder}") : null
    network                   = contains(keys(each.value), "portgroup") ? (contains(keys(each.value), "datacenter") ? ["/${each.value.datacenter}/network/${each.value.portgroup}"] : ["/${var.node_datacenter}/network/${each.value.portgroup}"]) : (contains(keys(each.value), "datacenter") ? ["/${each.value.datacenter}/network/${var.node_portgroup}"] : ["/${var.node_datacenter}/network/${var.node_portgroup}"])
    ssh_user                  = contains(keys(each.value), "template_ssh_user") ? each.value.template_ssh_user : var.node_template_ssh_user
    ssh_password              = contains(keys(each.value), "template_ssh_password") ? each.value.template_ssh_password : var.node_template_ssh_password
    ssh_user_group            = contains(keys(each.value), "template_ssh_user_group") ? each.value.template_ssh_user_group : var.node_template_ssh_user_group
    vapp_ip_allocation_policy = var.node_network_protocol_profile_addressing ? "fixedAllocated" : null
    vapp_ip_protocol          = var.node_network_protocol_profile_addressing ? "IPv4" : null
    vapp_transport            = var.node_network_protocol_profile_addressing ? "com.vmware.guestInfo" : null
    vapp_property = var.node_network_protocol_profile_addressing ? [
      contains(keys(each.value), "portgroup") ? "guestinfo.dns.servers=$${dns:${each.value.portgroup}}" : "guestinfo.dns.servers=$${dns:${var.node_portgroup}}",
      contains(keys(each.value), "portgroup") ? "guestinfo.dns.domain=$${domainName:${each.value.portgroup}}" : "guestinfo.dns.domain=$${domainName:${var.node_portgroup}}",
      contains(keys(each.value), "portgroup") ? "guestinfo.dns.searchpath=$${searchPath:${each.value.portgroup}}" : "guestinfo.dns.searchpath=$${searchPath:${var.node_portgroup}}",
      contains(keys(each.value), "portgroup") ? "guestinfo.interface.0.ip.0.address=ip:${each.value.portgroup}" : "guestinfo.interface.0.ip.0.address=ip:${var.node_portgroup}",
      contains(keys(each.value), "portgroup") ? "guestinfo.interface.0.ip.0.netmask=$${netmask:${each.value.portgroup}}" : "guestinfo.interface.0.ip.0.netmask=$${netmask:${var.node_portgroup}}",
      contains(keys(each.value), "portgroup") ? "guestinfo.interface.0.route.0.gateway=$${gateway:${each.value.portgroup}}" : "guestinfo.interface.0.route.0.gateway=$${gateway:${var.node_portgroup}}"
    ] : null
    cloud_config = contains(keys(each.value), "cloud_config") ? each.value.cloud_config : (var.node_cloud_config != null ? var.node_cloud_config : "#cloud-config")
  }
}

resource "rancher2_cluster" "cluster" {
  name                      = var.cluster_name
  description               = var.cluster_description
  enable_cluster_monitoring = var.enable_monitoring
  enable_cluster_alerting   = var.enable_alerting
  enable_cluster_istio      = var.enable_istio

  rke_config {
    kubernetes_version = var.kubernetes_version

    network {
      plugin = var.kubernetes_network_plugin
    }

    dynamic "private_registries" {
      for_each = var.private_registries_spec
      content {
        url        = private_registries.value.url
        user       = lookup(private_registries.value, "user", null)
        password   = lookup(private_registries.value, "password", null)
        is_default = lookup(private_registries.value, "is_default", null)
      }
    }

    dynamic "cloud_provider" {
      for_each = length(var.cloud_provider_spec) != 0 ? [var.cloud_provider_spec] : []
      content {
        name = "vsphere"
        vsphere_cloud_provider {
          global {
            insecure_flag        = lookup(cloud_provider.value, "global_insecure_flag", null)
            user                 = lookup(cloud_provider.value, "global_user", null)
            password             = lookup(cloud_provider.value, "global_password", null)
            datacenters          = lookup(cloud_provider.value, "global_datacenters", null)
            port                 = lookup(cloud_provider.value, "global_port", null)
            soap_roundtrip_count = lookup(cloud_provider.value, "global_soap_roundtrip_count", null)
          }
          dynamic "virtual_center" {
            for_each = cloud_provider.value.virtual_center_spec
            content {
              name                 = virtual_center.value.name
              user                 = virtual_center.value.user
              password             = virtual_center.value.password
              datacenters          = virtual_center.value.datacenters
              port                 = lookup(virtual_center.value, "port", null)
              soap_roundtrip_count = lookup(virtual_center.value, "soap_roundtrip_count", null)
            }
          }
          workspace {
            server            = cloud_provider.value.workspace_server
            datacenter        = cloud_provider.value.workspace_datacenter
            folder            = cloud_provider.value.workspace_folder
            default_datastore = lookup(cloud_provider.value, "workspace_default_datastore", null)
            resourcepool_path = lookup(cloud_provider.value, "workspace_resourcepool_path", null)
          }
          disk {
            scsi_controller_type = lookup(cloud_provider.value, "disk_scsi_controller_type", null)
          }
          network {
            public_network = lookup(cloud_provider.value, "network_public_network", null)
          }
        }
      }
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
