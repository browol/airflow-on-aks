# Airflow on AKS

This repository contains configurations and infrastructure templates for deploying Apache Airflow on Azure Kubernetes Service (AKS).

## Directory Structure

- **README.md**: You're reading it!
- **apps/**: Contains application-specific configurations.
  - **k8s/**: Kubernetes manifests for deploying applications.
    - **airflow/**: Configuration files for deploying Apache Airflow.
- **infrastructure/**: Infrastructure provisioning templates.
  - **k8s/**: Kubernetes manifests for infrastructure components.
  - **terraform/**: Terraform configurations for AKS setup.

## Usage

### Apache Airflow Deployment

- Navigate to the `apps/k8s/airflow/` directory for Apache Airflow deployment configurations.
- Customize the deployment according to your requirements.

### Infrastructure

- **Kubernetes (k8s):**
  - Contains Kubernetes manifests for deploying infrastructure components such as ingress controllers.
- **Terraform:**
  - Infrastructure provisioning templates for setting up Azure Kubernetes Service and related resources.

## Infrastructure Costs

The estimated monthly infrastructure costs for this project are as follows:

```bash
Detected Terragrunt directory at .
  ✔ Downloading Terraform modules
  ✔ Evaluating Terraform directory
  ✔ Retrieving cloud prices to calculate costs

Project: browol/airflow-on-aks/infrastructure/terraform/environments/dev/aks

 Name                                                              Monthly Qty  Unit                    Monthly Cost

 azurerm_container_registry.acr
 ├─ Registry usage (Basic)                                                  30  days                           $5.00
 ├─ Storage (over 10GB)                                      Monthly cost depends on usage: $0.10 per GB
 └─ Build vCPU                                               Monthly cost depends on usage: $0.0001 per seconds

 azurerm_kubernetes_cluster.aks
 ├─ default_node_pool
 │  ├─ Instance usage (Linux, pay as you go, Standard_B2ms)                730  hours                         $77.38
 │  └─ os_disk
 │     └─ Storage (P10, LRS)                                                 1  months                        $19.71
 └─ Load Balancer
    └─ Data processed                                        Monthly cost depends on usage: $0.005 per GB

 azurerm_kubernetes_cluster_node_pool.app[0]
 ├─ Instance usage (Linux, pay as you go, Standard_D4s_v3)                 730  hours                        $182.50
 └─ os_disk
    └─ Storage (P10, LRS)                                                    1  months                        $19.71

 azurerm_log_analytics_workspace.law
 ├─ Log data ingestion                                       Monthly cost depends on usage: $2.99 per GB
 ├─ Log data export                                          Monthly cost depends on usage: $0.13 per GB
 ├─ Basic log data ingestion                                 Monthly cost depends on usage: $0.65 per GB
 ├─ Basic log search queries                                 Monthly cost depends on usage: $0.0065 per GB searched
 ├─ Archive data                                             Monthly cost depends on usage: $0.026 per GB
 ├─ Archive data restored                                    Monthly cost depends on usage: $0.13 per GB
 └─ Archive data searched                                    Monthly cost depends on usage: $0.0065 per GB

 OVERALL TOTAL                                                                                               $304.30
──────────────────────────────────
14 cloud resources were detected:
∙ 5 were estimated, all of which include usage-based costs, see https://infracost.io/usage-file
∙ 9 were free:
  ∙ 2 x azurerm_role_assignment
  ∙ 2 x azurerm_user_assigned_identity
  ∙ 1 x azurerm_network_security_group
  ∙ 1 x azurerm_resource_group
  ∙ 1 x azurerm_subnet
  ∙ 1 x azurerm_subnet_network_security_group_association
  ∙ 1 x azurerm_virtual_network

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━┓
┃ Project                                                          ┃ Monthly cost ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━┫
┃ browol/airflow-on-aks/infrastru...terraform/environments/dev/aks ┃ $304         ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━┛
```

**Notes**:

- These are estimated costs and may vary based on usage.
- Reducing the node SKU would significantly reduce costs.
- Schedule the AKS shutdown on the weekend and after working hours to reduce costs by up to 26.67%.

## Getting Started

1. Configure Apache Airflow settings in the `apps/k8s/airflow/` directory.
2. Provision the infrastructure using either Kubernetes manifests in `infrastructure/k8s/` or Terraform configurations in `infrastructure/terraform/`.
3. Deploy Apache Airflow on AKS.
4. Monitor and manage Airflow workflows as needed.

## Contributing

Contributions are welcome! If you find bugs or want to enhance the project, feel free to submit issues or pull requests.

## License

This project is licensed under the [MIT License](LICENSE).
