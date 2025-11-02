#!/bin/bash
set -euo pipefail
# what does `set -euo pipefail` do? (notes)
# Ensures the script exits on error (-e), treats unset variables as errors (-u),
# and makes failure in pipelines cause the script to fail (-o pipefail).

set -euo pipefail

CLUSTER_NAME="atlan-sre-challenge"
REGION="ap-south-1"
NODEGROUP_NAME="atlan-nodes"
NODE_TYPE="t3.medium"
NODES=3

echo "[1/8] Creating EKS cluster without default nodegroup..."
eksctl create cluster \
  --name "${CLUSTER_NAME}" \
  --region "${REGION}" \
  --without-nodegroup

echo "[2/8] Deleting AWS VPC CNI DaemonSet..."
kubectl delete daemonset -n kube-system aws-node --ignore-not-found=true

echo "[3/8] Installing Calico via Helm..."
helm repo add projectcalico https://docs.tigera.io/calico/charts
helm repo update
kubectl create namespace tigera-operator || true

helm install calico projectcalico/tigera-operator \
  --version v3.31.0 \
  --namespace tigera-operator

echo "[4/8] Patching installation to use Calico as CNI..."
kubectl wait --for=condition=Available deployment tigera-operator -n tigera-operator --timeout=180s
kubectl patch installation default \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/cni", "value": {"type": "Calico"} }]'

echo "[5/8] Creating managed nodegroup..."
eksctl create nodegroup \
  --cluster "${CLUSTER_NAME}" \
  --region "${REGION}" \
  --name "${NODEGROUP_NAME}" \
  --node-type "${NODE_TYPE}" \
  --nodes "${NODES}" \
  --managed \
  --max-pods-per-node 100

echo "[6/8] Updating kubeconfig..."
aws eks update-kubeconfig --name "${CLUSTER_NAME}" --region "${REGION}"

echo "[7/8] Verifying Calico components..."
kubectl get pods -n tigera-operator
kubectl get pods -n calico-system
kubectl get daemonset -n calico-system

echo "[8/8] Verifying cluster nodes..."
kubectl get nodes -o wide

echo "EKS cluster '${CLUSTER_NAME}' setup complete with Calico CNI."
