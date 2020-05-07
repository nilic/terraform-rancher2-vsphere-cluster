variable "api_url" {}
variable "access_key" {}
variable "secret_key" {}

provider "rancher2" {
  api_url    = var.api_url
  access_key = var.access_key
  secret_key = var.secret_key
  insecure   = true
}

# cluster with static IP addressing for cluster nodes
# creates a cluster where network parameters are read from vSphere network protocol profiles and transferred to the VM through vApp properties
#
# in order for it to work, network protocol profile needs to be configured for the portgroup to which nodes are connected,
# IP pool with sufficient number of IP addresses should be set for the network protocol profile 
# and proper cloud-config should be included in order for the transferred properties to be read and actually configured inside the OS
#
# included cloud-config.yml is tested with CentOS 7.7
#
# for more information and example cloud-config for Ubuntu 18.04 take a look at
# https://www.virtualthoughts.co.uk/2020/03/29/rancher-vsphere-network-protocol-profiles-and-static-ip-addresses-for-k8s-nodes/
module "rancher_cluster_static_ip" {
  source = "../.."

  cloud_credential_name     = "MyVsphereCredentials"
  cluster_name              = "tf_test_static_ip"
  cluster_description       = "Terraform test Rancher K8s cluster"
  enable_monitoring         = true
  enable_alerting           = false
  enable_istio              = false
  kubernetes_network_plugin = "canal"

  node_vsphere_template                    = "MyFolder/k8s-node-template"
  node_datacenter                          = "MyDC"
  node_datastore                           = "MyDatastore"
  node_cluster                             = "MyCluster"
  node_resource_pool                       = "MyResourcePool"
  node_folder                              = "MyFolder"
  node_portgroup                           = "MyPortgroup"
  node_template_ssh_user                   = "root"
  node_template_ssh_password               = "MySecretPass"
  node_template_ssh_user_group             = "root"
  node_network_protocol_profile_addressing = true
  node_cloud_config                        = file("cloud-config.yml")

  node_spec = {
    master = {
      num_vcpu  = 2
      memory_gb = 4
      disk_gb   = 20
    }
    worker = {
      num_vcpu  = 4
      memory_gb = 8
      disk_gb   = 20
    }
  }

  master_node_quantity = 3
  worker_node_quantity = 3
}
