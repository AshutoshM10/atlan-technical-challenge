# 🚀 Atlan SRE-II Take Home Challenge

## Author
**Name:** Ashutosh Mohanty  
**Role Applied:** Site Reliability Engineer (SRE-II)  
**Date:** November 2, 2025  

---

## Overview

This repository contains my solution for Atlan's **SRE-II Take-Home Challenge**.  
It demonstrates my approach to:
- Diagnosing and fixing complex outages in a Kubernetes-based system.
- Correlating metrics and logs using Prometheus + Grafana.
- Applying SRE best practices for reliability and prevention.

---

## Tech Stack

| Component | Purpose |
|------------|----------|
| **EKS (AWS)** | Kubernetes cluster hosting the environment |
| **Prometheus + Grafana** | Monitoring & metrics visualization |
| **Frontend App** | Simple HTTP client (curl loop) |
| **Backend App** | Dummy API (httpbin) |
| **NetworkPolicy** | Used to simulate DNS blocking |
| **kubectl / helm / eksctl** | Cluster management tools |

---

## Objective
Provision a lightweight, personal EKS cluster to host the simulated outage environment for Atlan's SRE challenge.

---

## Commands

```bash
eksctl create cluster \
  --name atlan-sre-challenge \
  --region ap-south-1 \
  --nodegroup-name atlan-nodes \
  --node-type t3.medium \
  --nodes 2 \
  --managed
```
We can either run this or the script in `scripts/`
After creation:
```bash
aws eks update-kubeconfig --name atlan-sre-challenge --region ap-south-1
kubectl get nodes
```
