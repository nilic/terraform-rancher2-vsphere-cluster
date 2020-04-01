variable "api_url" {}
variable "access_key" {}
variable "secret_key" {}

provider "rancher2" {
  api_url    = var.api_url
  access_key = var.access_key
  secret_key = var.secret_key
  insecure   = true
}

# cluster with vSphere cloud provider and Docker private registry configuration
module "rancher_cluster_cloud_provider" {
  source = "../.."

  cloud_credential_name     = "MyVsphereCredentials"
  cluster_name              = "tf_test_consolidated"
  cluster_description       = "Terraform test Rancher K8s cluster"
  enable_monitoring         = true
  enable_alerting           = false
  enable_istio              = false
  kubernetes_network_plugin = "canal"

  private_registries_spec = {
    privreg1 = {
      url        = "myreg1.mydomain.com"
      user       = "myuser"
      password   = "mysecretpass"
      is_default = true
    }
    privreg2 = {
      url = "myreg2.mydomain.com"
    }
  }

  cloud_provider_spec = {
    global_insecure_flag = false
    virtual_center_spec = {
      myvcenter = {
        name                 = "myvcenter.mydomain.com"
        user                 = "myvcuser"
        password             = "mysecretpass"
        datacenters          = "/MyDC"
        port                 = 443
        soap_roundtrip_count = 0
      }
    }
    workspace_server            = "myvcenter.mydomain.com"
    workspace_datacenter        = "/MyDC"
    workspace_folder            = "/MyDC/vm/MyFolder"
    workspace_default_datastore = "MyDatastore"
    workspace_resourcepool_path = "/MyDC/host/MyCluster/Resources/MyResourcePool"
    disk_scsi_controller_type   = "pvscsi"
    network_public_network      = "MyPortgroup"
  }

  node_spec = {
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

  master_node_pool_name = "tf-master"
  master_node_prefix    = "tf-master-"
  master_node_quantity  = 3

  worker_node_pool_name = "tf-worker"
  worker_node_prefix    = "tf-worker-"
  worker_node_quantity  = 3
}
