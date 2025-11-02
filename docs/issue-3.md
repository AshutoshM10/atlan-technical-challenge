## Issue 3 — NetworkPolicy Enforcement (Calico CNI)

### Problem

Network connectivity between web and db pods was blocked after applying a Calico default-deny policy.

### Root Cause

Calico CNI was enforcing the following rule:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```
This blocked all ingress to the db pods.

---

### Setup

Apply deployments:
```bash
kubectl apply -f manifests/issue-3/db.yaml
kubectl apply -f manifests/issue-3/web.yaml
```

Check pod status:
```bash
kubectl get pods -o wide
NAME                                 STATUS    IP
db-9cb977fdc-xcfwv                   Running   192.168.20.215
web                                  Running   192.168.13.249
```

Check cluster nodes:
```bash
kubectl get nodes -o wide
NAME                                           STATUS
ip-192-168-43-164.ap-south-1.compute.internal  Ready
ip-192-168-64-85.ap-south-1.compute.internal   Ready
ip-192-168-9-199.ap-south-1.compute.internal   Ready
```

---

### Before policy

Web can reach db:
```bash
kubectl logs web | tail -n 10
```
output:
```html
<div class="check"><input type="checkbox" id="check" onchange="changeCookie()"> Auto Refresh</div>
    <div id="footer">
        <div id="center" align="center">
            Request ID: ed1603c2e2606035dafe2169378da963<br/>
            &copy; F5, Inc. 2020 - 2024
        </div>
    </div>
</body>
</html>

```

---

### After applying default-deny

Apply default-deny manifest:
```bash
kubectl apply -f manifests/default-deny.yaml
```

Logs show connection failure:
```bash
kubectl logs web | tail -n 5
connection failed
connection failed
connection failed
connection failed
```

---

### Resolution

Applied targeted allow rule:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-web-to-db
spec:
  podSelector:
    matchLabels:
      app: db
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: web
```

Apply the policy:
```bash
kubectl apply -f manifests/issue-3/allow-web-to-db.yaml
```

---

### Verification

Check current policies:
```bash
kubectl get networkpolicy
kubectl describe networkpolicy allow-web-to-db
```

Check logs to confirm restoration of connectivity:
```bash
kubectl logs web | tail -n 10 
```
output:
```html
<div class="check"><input type="checkbox" id="check" onchange="changeCookie()"> Auto Refresh</div>
    <div id="footer">
        <div id="center" align="center">
            Request ID: e1b0cdddbf6c233fc51967a5a3103e8b<br/>
            &copy; F5, Inc. 2020 - 2024
        </div>
    </div>
</body>
</html>
```

Traffic restored. Policy enforcement confirmed.

### Verification Evidence
```txt
$ kubectl get po
NAME                  READY   STATUS    RESTARTS   AGE
db-66b47dfcc7-c5kjd   1/1     Running   0          59m
web                   1/1     Running   0          59m
```
