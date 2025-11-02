# Add Helm repo
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```
# Install monitoring stack
```bash
helm install monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace
```
# Check that everything is running
```bash
kubectl get pods -n monitoring
```
# Forward Grafana locally
```bash
kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80
```
and then use [visit localhost:3000](http://localhost:3000/)
to get the password, use:
```bash
kubectl get secret -n monitoring monitoring-grafana \
  -o jsonpath="{.data.admin-password}" | base64 --decode
```


