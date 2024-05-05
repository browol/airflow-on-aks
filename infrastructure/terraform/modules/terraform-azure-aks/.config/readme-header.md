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
