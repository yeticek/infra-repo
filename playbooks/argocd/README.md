# ArgoCD

## Install
```bash
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
```

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
```bash
vagrant ssh vagrant-argo -c "kubectl -n argocd port-forward svc/argocd-server 8080:443"
```
Then open http://localhost:8080 in your browser and login with username `admin` and password as the name of the argocd-server pod.

Log in to argoCD CLI:
```bash
vagrant ssh vagrant-argo -c "ARGOCD_PASS=\$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d) && echo \"admin password: \$ARGOCD_PASS\""
vagrant ssh vagrant-argo -c "ARGOCD_PASS=\$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d) && argocd login localhost:8080 --username admin --password \"\$ARGOCD_PASS\" --insecure"
```

## Create ArgoCD application
```bash
vagrant ssh vagrant-argo -c "argocd app create nginx-html --repo https://github.com/<your-user>/<your-repo>.git --path playbooks/nginx/k8s --dest-server https://kubernetes.default.svc --dest-namespace web --sync-policy automated --auto-prune --self-heal"
vagrant ssh vagrant-argo -c "argocd app sync nginx-html"
vagrant ssh vagrant-argo -c "argocd app wait nginx-html --sync --health --timeout 300"
```

## Autosync check
Edit any file in nginx app.