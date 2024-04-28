# Istio Installation

## Prerequisites

Before installing Istio components on your Kubernetes cluster, ensure you have the following prerequisites:

- `kubectl`, `kustomize`, and `istioctl` CLIs installed on your local machine.

This command will apply necessary configurations to prepare your AKS cluster for Istio installation.

## Generate Istio Component Manifests

To install Istio components, follow these steps:

```bash
istioctl manifest generate -f operator/profile.yaml > k8s/istioctl-generated.yaml
```

## Installation

Run below command to install istio:

```bash
kustomize build k8s/ | kubectl apply -f -
```
