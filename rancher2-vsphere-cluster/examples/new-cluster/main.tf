variable "api_url" {}
variable "access_key" {}
variable "secret_key" {}

provider "rancher2" {
  api_url    = var.api_url
  access_key = var.access_key
  secret_key = var.secret_key
  insecure   = true
}

# cluster with separated control plane and etcd roles
## creates a cluster with two control plane, three etcd and three worker nodes, canal networking and monitoring enabled
module "rancher_cluster_separate_control_plane_etcd" {
  source = "../.."

  cloud_credential_name = "MyVsphereCredentials"
  cluster_name          = "tf_test"
  cluster_description   = "Terraform test Rancher K8s cluster"
  enable_monitoring     = true
  enable_alerting       = false
  enable_istio          = false
  k8s_network_plugin    = "canal"

  node_specs = {
    control_plane = {
      vsphere_template        = "MyFolder/k8s-control_plane"
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
    etcd = {
      vsphere_template        = "MyFolder/k8s-etcd"
      num_vcpu                = 1
      memory_gb               = 2
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
    worker = {
      vsphere_template        = "MyFolder/k8s-worker"
      num_vcpu                = 4
      memory_gb               = 8
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

  control_plane_node_pool_name = "tf-control_plane"
  control_plane_node_prefix    = "tf-control_plane-"
  control_plane_node_quantity  = 2

  etcd_node_pool_name = "tf-etcd"
  etcd_node_prefix    = "tf-etcd-"
  etcd_node_quantity  = 3

  worker_node_pool_name = "tf-worker"
  worker_node_prefix    = "tf-worker-"
  worker_node_quantity  = 3
}

# cluster with control plane and etcd roles consolidated into a master node role
## creates a cluster with three master (control plane + etcd) and three worker nodes, canal networking and monitoring enabled
module "rancher_cluster_consolidated_control_plane_etcd" {
  source = "../.."

  cloud_credential_name = "MyVsphereCredentials"
  cluster_name          = "tf_test_consolidated"
  cluster_description   = "Terraform test Rancher K8s cluster"
  enable_monitoring     = true
  enable_alerting       = false
  enable_istio          = false
  k8s_network_plugin    = "canal"

  node_specs = {
    master = {
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
    worker = {
      vsphere_template        = "MyFolder/k8s-worker"
      num_vcpu                = 4
      memory_gb               = 8
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

  master_node_pool_name = "tf-master"
  master_node_prefix    = "tf-master-"
  master_node_quantity  = 3

  worker_node_pool_name = "tf-worker"
  worker_node_prefix    = "tf-worker-"
  worker_node_quantity  = 3
}

# creates a cluster with one control plane, one etcd and one worker node, canal networking and monitoring enabled
module "rancher_cluster_minimum_inputs" {
  source = "../.."

  cloud_credential_name = "MyVsphereCredentials"
  cluster_name          = "tf_test_min"
  cluster_description   = "Terraform test Rancher K8s cluster 2"

  node_specs = {
    control_plane = {
      vsphere_template        = "k8s-control_plane"
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
    etcd = {
      vsphere_template        = "k8s-etcd"
      num_vcpu                = 1
      memory_gb               = 2
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
    worker = {
      vsphere_template        = "k8s-worker"
      num_vcpu                = 4
      memory_gb               = 8
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

  control_plane_node_quantity = 2
  etcd_node_quantity          = 3
  worker_node_quantity        = 2

}
