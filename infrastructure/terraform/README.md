# Provision AKS Cluster with Terragrunt

## Prerequisites

- Azure account with Owner role permissions on the Azure Subscription
- Terragrunt CLI version `v0.55.18` or higher (tested with this version)
- Terraform CLI version `v1.6.3` or higher (tested with this version)

## Example Usage

First, change the working directory to the target directory:

```bash
cd environments/dev/aks
```

Then, run `terragrunt plan` to preview the changes before applying:

```bash
terragrunt plan
```

Once you are satisfied with the changes in the plan, apply the changes using the following command:

```bash
terragrunt apply
```
