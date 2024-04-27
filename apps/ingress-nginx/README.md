# Ingress Nginx Helm Chart Installation Guide

## Introduction

This guide provides instructions for adding the Ingress Nginx Helm chart to your Kubernetes cluster using Helm.

## Prerequisites

Make sure you have the following prerequisites before proceeding:

- Helm v3.x or later installed on your local machine

## Installation

Update the load balancer IP address in the `values.yaml` file:

```bash
IP_ADDR=10.0.0.115
sed -i "s/{{LOAD_BALANCER_IP}}/${IP_ADDR}/" values.yaml

# If the above command doesn't work, try the following alternative:
sed -i '' "s/{{LOAD_BALANCER_IP}}/${IP_ADDR}/" values.yaml
```

Build a test:

```bash
kustomize build --enable-helm . | kubectl apply --validate='strict' --dry-run='client' -f -
```

Apply the installation:

```bash
kustomize build --enable-helm . | kubectl apply -f -
```

## Conclusion

You have successfully added the Ingress Nginx Helm chart to your Kubernetes cluster. You can now customize the chart's configuration and deploy resources according to your requirements.

For more information on configuring and managing Ingress Nginx, refer to the [Ingress Nginx Documentation](https://kubernetes.github.io/ingress-nginx/).
