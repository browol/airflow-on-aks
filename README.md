# Airflow on AKS

A sample repository features Apache Airflow deployed on an Azure Kubernetes Service (AKS) cluster

## Directory Structure

- **apps/**: Contains application-specific configurations.
  - **k8s/**: Kubernetes manifests for deploying applications.
    - **airflow/**: Configuration files for deploying Apache Airflow.
- **infrastructure/**: Infrastructure provisioning templates.
  - **k8s/**: Kubernetes manifests for infrastructure components.
  - **terraform/**: Terraform configurations for AKS setup.

## Usage

### Infrastructure

See [README.md](infrastructure/terraform/README.md)

#### Cost Estimation

The estimated monthly infrastructure costs for this project are as follows:

```bash
INFO Autodetected 1 Terragrunt project across 1 root module
INFO Found Terragrunt project main at directory .

Project: main

 Name                                                              Monthly Qty  Unit                    Monthly Cost

 azurerm_kubernetes_cluster_node_pool.app[0]
 ├─ Instance usage (Linux, pay as you go, Standard_D4s_v3)                 730  hours                        $182.50
 └─ os_disk
    └─ Storage (P10, LRS)                                                    1  months                        $19.71

 azurerm_kubernetes_cluster.aks
 ├─ default_node_pool
 │  ├─ Instance usage (Linux, pay as you go, Standard_B2ms)                730  hours                         $77.38
 │  └─ os_disk
 │     └─ Storage (P10, LRS)                                                 1  months                        $19.71
 └─ Load Balancer
    └─ Data processed                                        Monthly cost depends on usage: $0.005 per GB

 azurerm_container_registry.acr
 ├─ Registry usage (Basic)                                                  30  days                           $5.00
 ├─ Storage (over 10GB)                                      Monthly cost depends on usage: $0.10 per GB
 └─ Build vCPU                                               Monthly cost depends on usage: $0.0001 per seconds

 azurerm_public_ip.aks_pip
 └─ IP address (static, regional)                                          730  hours                          $3.65

 azurerm_log_analytics_workspace.law
 ├─ Log data ingestion                                       Monthly cost depends on usage: $2.99 per GB
 ├─ Log data export                                          Monthly cost depends on usage: $0.13 per GB
 ├─ Basic log data ingestion                                 Monthly cost depends on usage: $0.65 per GB
 ├─ Basic log search queries                                 Monthly cost depends on usage: $0.0065 per GB searched
 ├─ Archive data                                             Monthly cost depends on usage: $0.026 per GB
 ├─ Archive data restored                                    Monthly cost depends on usage: $0.13 per GB
 └─ Archive data searched                                    Monthly cost depends on usage: $0.0065 per GB

 OVERALL TOTAL                                                                                              $307.95

*Usage costs can be estimated by updating Infracost Cloud settings, see docs for other options.

──────────────────────────────────
18 cloud resources were detected:
∙ 6 were estimated
∙ 12 were free

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━┓
┃ Project                                            ┃ Baseline cost ┃ Usage cost* ┃ Total cost ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━╋━━━━━━━━━━━━┫
┃ main                                               ┃ $308          ┃ $0.00       ┃ $308       ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━┻━━━━━━━━━━━━┛
```

**Notes**:

- These are estimated costs and may vary based on usage.
- Reducing the node SKU would significantly reduce costs.
- Schedule the AKS shutdown on the weekend and after working hours to reduce costs by up to 26.67%.

### Applications

See [README.md](apps/README.md)

## Contributing

Contributions are welcome! If you find bugs or want to enhance the project, feel free to submit issues or pull requests.

## License

This project is licensed under the [MIT License](LICENSE).
