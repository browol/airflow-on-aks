# Airflow on AKS

This repository contains configurations and infrastructure templates to deploy Apache Airflow on Azure Kubernetes Service (AKS).

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

- Navigate to `apps/k8s/airflow/` directory for Apache Airflow deployment configurations.
- Customize the deployment as per your requirements.

### Infrastructure

- **Kubernetes (k8s):**
  - Contains Kubernetes manifests for deploying infrastructure components such as ingress controllers.
- **Terraform:**
  - Infrastructure provisioning templates to set up Azure Kubernetes Service and related resources.

## Getting Started

1. Configure Apache Airflow settings in the `apps/k8s/airflow/` directory.
2. Provision the infrastructure using either Kubernetes manifests in `infrastructure/k8s/` or Terraform configurations in `infrastructure/terraform/`.
3. Deploy Apache Airflow on AKS.
4. Monitor and manage Airflow workflows as needed.

## Contributing

Contributions are welcome! If you find bugs or want to enhance the project, feel free to submit issues or pull requests.

## License

This project is licensed under the [MIT License](LICENSE).
