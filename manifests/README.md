# Deployment Frontend & Backend Applications

## Objective
Deploying a minimal two-service app inside the EKS cluster, a backend (dummy API) and a frontend (HTTP client calling the backend).

## Setup
```bash
kubectl apply -f manifests/backend.yaml
kubectl apply -f manifests/frontend.yaml
```

## Verification
```bash
kubectl get pods
kubectl exec -it deploy/frontend -- curl backend-svc
```
Both services respond successfully; this forms the baseline healthy state.
