<!-- BEGIN_TF_DOCS -->
# Terraform Private Azure Kubernetes Service (AKS) cluster

[![Terraform tests](https://github.com/browol/terraform-azure-aks-example/actions/workflows/terraform-tests.yml/badge.svg)](https://github.com/browol/terraform-azure-aks-example/actions/workflows/terraform-tests.yml)
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
az aks command invoke --resource-group rg-d-ea1-browol-infra --name aks-d-ea1-browol-infra-jm5t --command "kubectl get nodes"
```

See <https://learn.microsoft.com/en-us/azure/aks/access-private-cluster?tabs=azure-cli>

## Troubleshooting

### KubernetesPerformanceError: Failed to run command due to cluster perf issue

An error occurred while attempting to run the `az aks command invoke` command.

```bash
az aks command invoke --resource-group rg-d-ea1-browol-infra --name aks-d-ea1-browol-infra-jm5t --command "kubectl get nodes"
(KubernetesPerformanceError) Failed to run the command due to cluster performance issues. The container command-9f71543a9f184b568827005379d4b513 in the aks-command namespace did not start within 30 seconds on your cluster. Retrying may help. If the issue persists, you may need to optimize your cluster for better performance (larger node/paid tier).
Code: KubernetesPerformanceError
Message: Failed to run the command due to cluster performance issues. The container command-9f71543a9f184b568827005379d4b513 in the aks-command namespace did not start within 30 seconds on your cluster. Retrying may help. If the issue persists, you may need to optimize your cluster for better performance (larger node/paid tier).
```

This issue is caused by the pod that was used to execute the invoke command for you being unable to provision successfully, leading to the above error message.

Here's what the pods look like:

```bash
NAME                                       READY   STATUS            RESTARTS   AGE
command-9f71543a9f184b568827005379d4b513   0/1     Pending           0          8m5s
command-b3660a6f94b74677b3bf55315a6b929c   0/1     Pending           0          8m46s
```

To resolve the issue, you need to remove the node taint as per your declaration in Terraform:

```hcl
resource "azurerm_kubernetes_cluster" "aks" {
  default_node_pool {
    # comment out below line
    # only_critical_addons_enabled = true
  }
}
```

After updates were applied, you will be able to run the `az aks command invoke` properly.

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
| [azurerm_private_dns_zone.aks](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.link](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.aks_managed_kubelet](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_private_dns](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.kubelet_acr](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/role_assignment) | resource |
| [azurerm_subnet.nodepool](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.nodepool_default](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_user_assigned_identity.aks](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.kubelet](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.92.0/docs/resources/virtual_network) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_command"></a> [command](#output\_command) | placeholder command to remotely execute a Kubernetes command |

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
<!-- END_TF_DOCS -->
