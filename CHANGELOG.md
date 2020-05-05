## 2.6.3 (May 5, 2020)
NOTES:
* Fixed wrong variable name in one of the example files 

## 2.6.2 (April 1, 2020)
NOTES:
* Updated module readme using `terraform-docs` v0.9.0 

## 2.6.1 (April 1, 2020)
NOTES:
* Renamed and reorganized the repository for the purpose of publishing the module to Terraform registry

## 2.6.0 (March 31, 2020)
FEATURES:
* `rancher2-vsphere-cluster`: Added support for transferring network information (such as IP addresses, default gateway, DNS servers, DNS domain etc) through vApp properties to cluster nodes using node portgroup's network protocol profile. This is done by setting variable `node_network_protocol_profile_addressing` to `true` and can be used along with proper `cloud_config` configuration for setting static IP addresses on cluster nodes

## 2.5.0 (March 29, 2020)
FEATURES:
* `rancher2-vsphere-cluster`: Added support for specifying cloud-config YAML for cluster nodes, either through global setting `node_cloud_config` or through a local `cloud_config` parameter inside `node_spec`; contents of a cloud-config YAML file should be passed to the module, and this can be done either by defining YAML inline using Terraform's `heredoc` synthax or by loading it from a file using Terraform's `file()` function; cloud-config spec is optional, if omitted, cloud-config file will be left empty (set to `#cloud-config`)

## 2.4.0 (March 29, 2020)

FEATURES:
* `rancher2-vsphere-cluster`: Added support for global node specifications through module input variables starting with `node_`; this allows parameters such as vSphere template, datacenter, cluster, resource pool, folder, datastore, portgroup, SSH user, SSH password and SSH user group to be set once and then applied for all cluster nodes; value of these parameters can be overridden by setting them locally through `node_spec`; only input parameters that cannot be set globally and need to be set per each node role using `node_spec` are number of vCPUs, memory and disk size

IMPROVEMENTS:
* `rancher2-vsphere-cluster`: resource pool and VM folder are now optional parameters for cluster nodes; if omitted, nodes will be created in cluster and datacenter root
* `rancher2-vsphere-cluster`: updated examples and split them into multiple files

## 2.3.0 (March 28, 2020)
FEATURES:
* `rancher2-vsphere-cluster`: Added support for defining which Kubernetes version to deploy through variable `kubernetes_version`
* `rancher2-vsphere-cluster`: Added support for defining private Docker registries for the cluster through variable `private_registries_spec`

BREAKING CHANGES:
* `rancher2-vsphere-cluster`: Changed names of variables `k8s_network_plugin` to `kubernetes_network_plugin` and `node_specs` to `node_spec`

## 2.2.0 (March 27, 2020)

FEATURES:
* `rancher2-vsphere-cluster`: Added support for setting vSphere cloud provider configuration, which allows for dynamic provisioning of volumes

## 2.1.0 (March 26, 2020)

FEATURES:
* `rancher2-vsphere-cluster`: Added possibility to create a single node K8s cluster which could be useful for development, testing and learning purposes; this type of cluster uses a new node role called `all_in_one`

BUG FIXES:
* `rancher2-vsphere-cluster`: Fixed default value for variable `control_plane_node_pool_name`, which would cause an error when creating the node pool, since the name should be RFC 1123 compliant

## 2.0.0 (March 25, 2020)

IMPROVEMENTS:
* `rancher2-vsphere-cluster`: Renamed node role names to comply with generally accepted conventions; available node roles are now `control_plane`, `etcd`, `master` (consolidated `control_plane` and `etcd`) and `worker`
* switched to semantic versioning

## 1.0 (February 29, 2020)

FEATURES:

* **New module**: `rancher2-vsphere-cluster`

