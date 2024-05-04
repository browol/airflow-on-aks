# ArgoCD

## Prerequisites

Before installing ArgoCD, ensure you have the following:

1. **Access to a Kubernetes Cluster**: ArgoCD runs on Kubernetes, so you need access to a Kubernetes cluster. You can use managed Kubernetes services like AKS, GKE, or EKS, or set up your own cluster using tools like Minikube or kubeadm.
2. **kubectl CLI**: Install the `kubectl` command-line tool to interact with your Kubernetes cluster.
3. **Azure CLI (Optional)**: If you're using Azure AKS and intend to deploy the Git credential secret using Azure CLI, make sure you have it installed and configured.
4. **Git Credentials**: You'll need Git credentials (username and password) or SSH key with appropriate access to your Git repository.

## Installation

To install ArgoCD, follow the steps below:

### Git Credential

Create ArgoCD namespace

```bash
kubectl create namespace infra-argocd
```

Create a Kubernetes Secret YAML file named `secret.yaml` with the following content:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  annotations:
    managed-by: argocd.argoproj.io
  labels:
    argocd.argoproj.io/secret-type: repository
  name: git-credentials-https
  namespace: infra-argocd
stringData:
  url: https://github.com/browol/airflow-on-aks.git
  type: git
  username: browol
  password: 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
EOF
```

Notes:

- In the case of a private Kubernetes cluster, use `az aks command invoke -g $RG -n $AKS_CLUSTER --file. --command "$CMD"` to proxy your command to the private Kubernetes API.
- Ensure to replace `$RG` and `$AKS_CLUSTER` with your resource group and AKS cluster name respectively, and set `my-username` and `my-password` with your Git credentials accordingly. Adjust other configurations as needed for your environment.

### Helm Chart

Add ArgoCD Helm repository, and install ArgoCD using Helm:

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd --namespace=infra-argocd --create-namespace --values=values.yaml --set crds.install=true --version=6.4.1
```

Create ArgoCD applications:

```bash
kubectl apply -f applications
```

Notes:

- In the case of a private Kubernetes cluster, use `az aks command invoke -g $RG -n $AKS_CLUSTER --file. --command "$CMD"` to proxy your command to the private Kubernetes API.
- Ensure to replace `$RG` and `$AKS_CLUSTER` with your resource group and AKS cluster name respectively, and set `my-username` and `my-password` with your Git credentials accordingly. Adjust other configurations as needed for your environment.

## Bonus

To grant cluster-admin role to ArgoCD service account

```bash
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cluster-admin:argocd-server
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: argocd-server
  namespace: infra-argocd
EOF
```

Login into ArgoCD server

```bash
argocd login --core localhost:80
```

List all applications

```bash
argocd app list
```
