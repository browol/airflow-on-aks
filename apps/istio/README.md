# Istio Installation

## Prerequisites

Before installing Istio components on your Kubernetes cluster, ensure you have the following prerequisites:

- `kubectl`, `kustomize`, and `istioctl` CLIs installed on your local machine.

This command will apply necessary configurations to prepare your AKS cluster for Istio installation.

## Installation

To install Istio components, follow these steps:

```bash
kubectl create namespace infra-istio
istioctl manifest generate -f operator/profile.yaml | kubectl apply -f -
```

then run below command to install istio components:

```bash
kustomize build k8s/ | kubectl apply -f -
```
