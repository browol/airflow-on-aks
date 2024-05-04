# Ingress Nginx Helm Chart Installation Guide

## Introduction

This guide provides instructions for adding the Ingress Nginx Helm chart to your Kubernetes cluster using Helm.

## Prerequisites

Make sure you have the following prerequisites before proceeding:

- Helm v3.x or later installed on your local machine

## Installation

Build test:

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
