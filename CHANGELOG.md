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

