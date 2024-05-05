<!-- BEGIN_TF_DOCS -->
# Terraform Public Azure Kubernetes Service (AKS) cluster

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository provides a simple example of how to use Terragrunt to provision an Azure Kubernetes Service in the private network.

## Prerequisites

Before you begin, ensure you have the following prerequisites:

- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) installed locally.
- An Azure subscription. If you don't have one, you can sign up for a free account [here](https://azure.microsoft.com/en-us/free/).
- Azure CLI installed and configured with appropriate permissions. Instructions can be found [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
- Basic knowledge of Terragrunt and Terraform, as well as Azure services.

## Usage

Apply the Terraform configuration using Terragrunt:

```bash
terragrunt run-all apply
```

To clean up the resources created by Terragrunt, run:

```bash
terragrunt run-all destroy
```

## Access to cluster

Example:

```bash
az aks get-credentials --resource-group <aks-resource-group-name> --name <aks-cluster-name> --overwrite-existing
kubelogin convert-kubeconfig -l azurecli
```

See <https://learn.microsoft.com/en-us/azure/aks/access-private-cluster?tabs=azure-cli>

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.92.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_naming"></a> [naming](#module\_naming) | Azure/naming/azurerm | 0.4.0 |
| <a name="module_region"></a> [region](#module\_region) | claranet/regions/azurerm | 7.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/container_registry) | resource |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.app](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_log_analytics_workspace.law](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_diagnostic_setting.aks](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_network_security_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.allow_http_load_balancer](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_https_load_balancer](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/network_security_rule) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.aks_managed_kubelet](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.kubelet_acr](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/role_assignment) | resource |
| [azurerm_subnet.nodepool](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.nodepool_default](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_user_assigned_identity.aks](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.kubelet](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/virtual_network) | resource |
| [azurerm_lb.aks_lb](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/data-sources/lb) | data source |
| [azurerm_public_ip.aks_lb_pip](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/data-sources/public_ip) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_admin_group_object_id"></a> [aad\_admin\_group\_object\_id](#input\_aad\_admin\_group\_object\_id) | n/a | `string` | n/a | yes |
| <a name="input_client"></a> [client](#input\_client) | n/a | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_environment_short"></a> [environment\_short](#input\_environment\_short) | n/a | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | n/a | `string` | n/a | yes |
| <a name="input_stack"></a> [stack](#input\_stack) | n/a | `string` | n/a | yes |
| <a name="input_subnet_addr_prefix"></a> [subnet\_addr\_prefix](#input\_subnet\_addr\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_vnet_addr_prefix"></a> [vnet\_addr\_prefix](#input\_vnet\_addr\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_system_nodepool"></a> [system\_nodepool](#input\_system\_nodepool) | n/a | `map(string)` | <pre>{<br>  "max_count": 1,<br>  "min_count": 1,<br>  "os_disk_type": "Managed",<br>  "vm_size": "Standard_B2ms"<br>}</pre> | no |
| <a name="input_user_nodepool"></a> [user\_nodepool](#input\_user\_nodepool) | n/a | `map(string)` | <pre>{<br>  "enabled": true,<br>  "max_count": 1,<br>  "min_count": 1,<br>  "os_disk_type": "Managed",<br>  "vm_size": "Standard_D4s_v3"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_command"></a> [command](#output\_command) | Example command for remote execution in the Azure Kubernetes cluster |

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
<!-- END_TF_DOCS -->
