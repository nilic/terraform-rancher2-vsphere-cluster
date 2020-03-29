variable "api_url" {}
variable "access_key" {}
variable "secret_key" {}

provider "rancher2" {
  api_url    = var.api_url
  access_key = var.access_key
  secret_key = var.secret_key
  insecure   = true
}

# single node cluster with all roles consolidated on one node
## creates a cluster with one node with control plane, etcd and worker roles, canal networking and monitoring enabled
module "rancher_cluster_single_node" {
  source = "../.."

  cloud_credential_name     = "MyVsphereCredentials"
  cluster_name              = "tf_test_single_node"
  cluster_description       = "Terraform test Rancher K8s cluster"
  enable_monitoring         = true
  enable_alerting           = false
  enable_istio              = false
  kubernetes_network_plugin = "canal"

  node_spec = {
    all_in_one = {
      vsphere_template        = "MyFolder/k8s-master"
      num_vcpu                = 2
      memory_gb               = 4
      disk_gb                 = 20
      datacenter              = "MyDC"
      datastore               = "MyDatastore"
      cluster                 = "MyCluster"
      resource_pool           = "MyResourcePool"
      folder                  = "MyFolder"
      portgroup               = "MyPortgroup"
      template_ssh_user       = "root"
      template_ssh_password   = "MySecretPass"
      template_ssh_user_group = "root"
    }
  }

  single_node_cluster = true
}
