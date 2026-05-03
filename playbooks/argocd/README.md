# ArgoCD

## Install on k8s cluster
Install on vagrant-argo instance
```bash
vagrant ssh vagrant-argo -c "kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -"
vagrant ssh vagrant-argo -c "kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
vagrant ssh vagrant-argo -c "kubectl -n argocd rollout status deploy/argocd-server --timeout=300s"
vagrant ssh vagrant-argo -c "command -v argocd >/dev/null || (curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 && sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd && rm argocd-linux-amd64)"
vagrant ssh vagrant-argo -c "argocd version --client"
```

## Access ArgoCD UI
Port-forward must run on the node hosting the `argocd-server` pod (`vagrant-argo`).
`vagrant-argo` is a worker node and has no kubeconfig by default — copy it from the control plane first:
```bash
vagrant ssh vagrant-infra -c "cat ~/.kube/config" > /tmp/kube_infra_config
vagrant ssh vagrant-argo -c "mkdir -p ~/.kube && cat > ~/.kube/config" < /tmp/kube_infra_config
rm /tmp/kube_infra_config
# verify
vagrant ssh vagrant-argo -c "kubectl get nodes"
```

`kubectl port-forward` routes through the API server → kubelet and is blocked in this multi-node Vagrant setup.
Use **NodePort** instead:
```bash
# Patch service to NodePort
vagrant ssh vagrant-argo -c "kubectl -n argocd patch svc argocd-server -p '{\"spec\":{\"type\":\"NodePort\"}}'"

# Get the assigned NodePort (look for 443:XXXXX/TCP)
vagrant ssh vagrant-argo -c "kubectl -n argocd get svc argocd-server"

# SSH tunnel host:30400 → vagrant-argo:<NodePort>  (replace 31234 with actual port)
vagrant ssh vagrant-argo -- -L 30400:localhost:30400
```
Then open **https://localhost:30400** in your browser (accept the self-signed cert) and login with username `admin`.

Get the initial admin password:
```bash
vagrant ssh vagrant-argo -c "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d && echo"
```

Log in to argoCD CLI (while SSH tunnel is active on localhost:8080):
```bash
vagrant ssh vagrant-argo -c "ARGOCD_PASS=\$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d) && echo \"admin password: \$ARGOCD_PASS\""
# Login from your host (tunnel must be open)
ARGOCD_PASS=$(vagrant ssh vagrant-argo -c "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d")
argocd login localhost:30400 --username admin --password "$ARGOCD_PASS" --insecure
```

## Create ArgoCD application
```bash
vagrant ssh vagrant-argo -c "argocd app create nginx-html --repo https://github.com/yeticek/infra-repo.git --path playbooks/nginx/k8s --dest-server https://kubernetes.default.svc --dest-namespace web --sync-policy automated --auto-prune --self-heal"
vagrant ssh vagrant-argo -c "argocd app sync nginx-html"
vagrant ssh vagrant-argo -c "argocd app wait nginx-html --sync --health --timeout 300"
```
If this fails then use argoCD UI to check the error message and fix it (e.g. missing namespace, wrong path, etc.) then sync again.
Or create the app from UI manually.

## Autosync check
Edit any file in nginx app.