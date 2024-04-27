# Airflow Helm Chart Installation Guide

## Introduction

This guide provides instructions for adding the Apache Airflow Helm chart to your Kubernetes cluster using Helm.

## Prerequisites

- Helm v3.x or later installed on your local machine

## Installation

Build test

```bash
kustomize build --enable-helm . | kubectl apply --validate='strict' --dry-run='client' -f -
```

Apply installation

```bash
kustomize build --enable-helm . | kubectl apply -f -
```

## Conclusion

You have successfully added the Apache Airflow Helm chart to your Kubernetes cluster. You can now customize the chart's configuration and deploy Airflow according to your requirements.

For more information on configuring and managing Airflow, refer to the [Apache Airflow Documentation](https://airflow.apache.org/docs/apache-airflow/stable/start/index.html).
