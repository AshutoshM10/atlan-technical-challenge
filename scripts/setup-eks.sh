#!/bin/bash
set -e

CLUSTER_NAME="atlan-sre-challenge"
REGION="ap-south-1"

echo ">>> Creating EKS cluster: $CLUSTER_NAME ..."
eksctl create cluster \
  --name $CLUSTER_NAME \
  --region $REGION \
  --nodegroup-name atlan-nodes \
  --node-type t3.medium \
  --nodes 2 \
  --managed

echo "Updating kubeconfig ..."
aws eks update-kubeconfig --name $CLUSTER_NAME --region $REGION

echo "Verifying nodes: "
kubectl get nodes -o wide
echo "Cluster setup complete: "
