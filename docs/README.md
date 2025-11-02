## Issue 1 — Service Connectivity
**Problem:** Frontend → backend unreachable.  
**Root Cause:** Service selector mismatch.  
**Fix:** Updated selector; verified endpoints & connectivity.  
**Evidence:**  
before:
![Before](../screenshots/issue-1-before.png)  
after:
![After](../screenshots/grafana-service-connectivity-after.png)

## Issue 2 — OOMKilled Pod
**Problem:** Frontend pod terminated with exit 137.  
**Root Cause:** Memory limit too low.  
**Fix:** Increased limit; verified stable metrics.  
**Evidence:**  
before:
![Memory Before](../screenshots/issue-2-before.png)  
after:
![Memory After](../screenshots/issue-2-after.png)

## Issue 3 — Network Policy Enforcement
**Problem:** Network isolation validation.  
**Fix:** Applied default-deny and allow-web-to-db policies.  
**Evidence:**  
before:
![Policy Block](../screenshots/issue-3-before.png)  
after:
![Policy Allow](../screenshots/issue-3-after.png)

## Monitoring
Installed kube-prometheus-stack with Grafana dashboards:
- Pod resource utilization
- Service connectivity
- Network IO  

## Lessons Learned
- Always validate selectors with `kubectl get endpoints`
- Use Grafana to baseline normal pod memory usage
- Default-deny NetworkPolicies should be applied cluster-wide
