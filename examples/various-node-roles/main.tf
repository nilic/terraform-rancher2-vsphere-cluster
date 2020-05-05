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

  cloud_credential_name     = "MyVsphereCredentials"
  cluster_name              = "tf_test"
  cluster_description       = "Terraform test Rancher K8s cluster"
  enable_monitoring         = true
  enable_alerting           = false
  enable_istio              = false
  kubernetes_network_plugin = "canal"
  kubernetes_version        = "v1.17.4-rancher1-1"

  node_spec = {
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
      cloud_config            = file("cloud-config.yml")
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
      cloud_config            = file("cloud-config.yml")
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
      cloud_config            = file("cloud-config.yml")
    }
  }

  control_plane_node_pool_name = "tf-control-plane"
  control_plane_node_prefix    = "tf-control-plane-"
  control_plane_node_quantity  = 2

  etcd_node_pool_name = "tf-etcd"
  etcd_node_prefix    = "tf-etcd-"
  etcd_node_quantity  = 3

  worker_node_pool_name = "tf-worker"
  worker_node_prefix    = "tf-worker-"
  worker_node_quantity  = 3
}

# same as above but using global node specs for node parameters that are same for all the nodes
module "rancher_cluster_separate_control_plane_etcd_global_spec" {
  source = "../.."

  cloud_credential_name     = "MyVsphereCredentials"
  cluster_name              = "tf_test"
  cluster_description       = "Terraform test Rancher K8s cluster"
  enable_monitoring         = true
  enable_alerting           = false
  enable_istio              = false
  kubernetes_network_plugin = "canal"
  kubernetes_version        = "v1.17.4-rancher1-1"

  node_datacenter              = "MyDC"
  node_datastore               = "MyDatastore"
  node_cluster                 = "MyCluster"
  node_resource_pool           = "MyResourcePool"
  node_folder                  = "MyFolder"
  node_portgroup               = "MyPortgroup"
  node_template_ssh_user       = "root"
  node_template_ssh_password   = "MySecretPass"
  node_template_ssh_user_group = "root"
  node_cloud_config            = file("cloud-config.yml")

  node_spec = {
    control_plane = {
      vsphere_template = "MyFolder/k8s-control_plane"
      num_vcpu         = 2
      memory_gb        = 4
      disk_gb          = 20
    }
    etcd = {
      vsphere_template = "MyFolder/k8s-etcd"
      num_vcpu         = 1
      memory_gb        = 2
      disk_gb          = 20
    }
    worker = {
      vsphere_template = "MyFolder/k8s-worker"
      num_vcpu         = 4
      memory_gb        = 8
      disk_gb          = 20
    }
  }

  control_plane_node_pool_name = "tf-control-plane"
  control_plane_node_prefix    = "tf-control-plane-"
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
## global node specs are used
module "rancher_cluster_consolidated_control_plane_etcd" {
  source = "../.."

  cloud_credential_name     = "MyVsphereCredentials"
  cluster_name              = "tf_test_consolidated"
  cluster_description       = "Terraform test Rancher K8s cluster"
  enable_monitoring         = true
  enable_alerting           = false
  enable_istio              = false
  kubernetes_network_plugin = "canal"

  node_vsphere_template        = "MyFolder/k8s-node-template"
  node_datacenter              = "MyDC"
  node_datastore               = "MyDatastore"
  node_cluster                 = "MyCluster"
  node_resource_pool           = "MyResourcePool"
  node_folder                  = "MyFolder"
  node_portgroup               = "MyPortgroup"
  node_template_ssh_user       = "root"
  node_template_ssh_password   = "MySecretPass"
  node_template_ssh_user_group = "root"
  node_cloud_config            = file("cloud-config.yml")

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

# same as above but with network parameters read from vSphere network protocol profiles and transferred to the VM through vApp properties
# this is useful for setting static IPv4 addresses on cluster nodes
# in order for it to work, network protocol profile needs to be configured for the portgroup to which nodes are connected
# and proper cloud-config should be included in order for the transferred properties to be read and actually configured inside the OS
module "rancher_cluster_consolidated_control_plane_etcd_npp" {
  source = "../.."

  cloud_credential_name     = "MyVsphereCredentials"
  cluster_name              = "tf_test_consolidated_npp"
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
