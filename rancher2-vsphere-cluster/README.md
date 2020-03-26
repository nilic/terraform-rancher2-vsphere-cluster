## Providers

| Name | Version |
|------|---------|
| rancher2 | >= 1.7.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| all\_in\_one\_node\_pool\_name | Name of the all-in-one node pool | `string` | `"all-in-one"` | no |
| all\_in\_one\_node\_prefix | Prefix for node created in the all-in-one node pool | `string` | `"all-in-one-"` | no |
| cloud\_credential\_name | Name of vSphere cloud credential | `string` | n/a | yes |
| cluster\_description | Cluster description | `string` | n/a | yes |
| cluster\_name | Cluster name | `string` | n/a | yes |
| control\_plane\_node\_pool\_name | Name of the control plane node pool | `string` | `"control-plane"` | no |
| control\_plane\_node\_prefix | Prefix for nodes created in control plane node pool | `string` | `"control-plane-"` | no |
| control\_plane\_node\_quantity | Number of nodes in control plane node pool | `number` | n/a | yes |
| enable\_alerting | Whether to enable cluster alerting | `bool` | `false` | no |
| enable\_istio | Whether to enable Istio for the cluster | `bool` | `false` | no |
| enable\_monitoring | Whether to enable cluster monitoring | `bool` | `true` | no |
| etcd\_node\_pool\_name | Name of the etcd node pool | `string` | `"etcd"` | no |
| etcd\_node\_prefix | Prefix for nodes created in etcd node pool | `string` | `"etcd-"` | no |
| etcd\_node\_quantity | Number of nodes in etcd node pool | `number` | n/a | yes |
| k8s\_network\_plugin | Which K8s network plugin to use, one of `canal`, `flannel`, `calico`, `weave` | `string` | `"canal"` | no |
| master\_node\_pool\_name | Name of the master (consolidated control plane and etcd) node pool | `string` | `"master"` | no |
| master\_node\_prefix | Prefix for nodes created in master (consolidated control plane and etcd) node pool | `string` | `"master-"` | no |
| master\_node\_quantity | Number of nodes in master (consolidated control plane and etcd) node pool | `number` | n/a | yes |
| node\_specs | Specification of node templates, take a look at the `examples` directory for synthax | `any` | n/a | yes |
| single\_node\_cluster | Whether to create a single node cluster with all roles consolidated on one node | `bool` | `false` | no |
| worker\_node\_pool\_name | Name of the worker node pool | `string` | `"worker"` | no |
| worker\_node\_prefix | Prefix for nodes created in worker node pool | `string` | `"worker-"` | no |
| worker\_node\_quantity | Number of nodes in worker node pool | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the created cluster |
| kube\_config | kubeconfig of the created cluster |

