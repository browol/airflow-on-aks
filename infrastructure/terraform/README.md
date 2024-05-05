# Provision AKS Cluster with Terragrunt

## Prerequisites

- Azure account with Owner role permissions on the Azure Subscription
- terragrunt CLI version `v0.55.18` or higher (tested with this version)
- terrafrom CLI version `v1.6.3` or higher (tested with this version)
- kubectl CLI version `v1.29.2` or higher (tested with this version)

## Example Usage

Run infrastructure plan to preview the changes before applying:

```bash
terragrunt run-all plan --terragrunt-working-dir environments/dev
```

Once you are satisfied with the changes in the plan, apply the changes using the following command:

```bash
terragrunt run-all apply --terragrunt-working-dir environments/dev
```

## Access AKS Cluster

Getting AKS Cluster configuration

```bash
az aks get-credentials --resource-group <aks-resource-group-name> --name <aks-cluster-name> --overwrite-existing
kubelogin convert-kubeconfig -l azurecli
```

Test run kubectl command:

```bash
kubectl get nodes
```

Done.
