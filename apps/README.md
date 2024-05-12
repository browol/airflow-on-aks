# Kubernetes Application Installation Guide

This guide provides instructions for installing applications on a Kubernetes cluster using Kustomize and Helm.

## Prerequisites

Before proceeding with the installation, ensure the following prerequisites are met:

- Access to a Kubernetes cluster
- `kubectl` command-line tool installed and configured to connect to the cluster
- `kustomize` and `helm` installed on your local machine

## Installation Steps

Follow these steps to install the applications:

### Istio

Run the following command to install Istio using Kustomize and Helm:

```bash
kustomize build --enable-helm istio/k8s | kubectl apply -f -
```

This command will apply the Istio resources to your Kubernetes cluster.

### NGINX Ingress Controller

Install NGINX Ingress Controller using Kustomize and Helm:

```bash
kustomize build --enable-helm ingress-nginx | kubectl apply -f -
```

This command will deploy NGINX Ingress Controller resources to your cluster.

### Cert-Manager

Install Cert-Manager using Kustomize and Helm:

```bash
kustomize build --enable-helm cert-manager | kubectl apply -f -
```

This command will apply Cert-Manager resources for managing TLS certificates.

### Airflow

Finally, install Airflow using Kustomize and Helm:

```bash
kustomize build --enable-helm airflow/ | kubectl apply -f -
```

This command will deploy Airflow resources to your Kubernetes cluster.

## Verification

After applying the configurations, verify that the applications are installed correctly by checking their respective pods, services, and ingresses:

```bash
kubectl get pods
kubectl get services
kubectl get ingresses
```

Ensure that all necessary pods are in a `Running` state and services are exposed correctly.

## Conclusion

You have successfully installed the specified applications on your Kubernetes cluster using Kustomize and Helm.
