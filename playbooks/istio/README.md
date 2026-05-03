# Istio service mesh

Install Istio control plane on the Kubernetes cluster running on `vagrant-infra`.

Default dev settings use the `minimal` profile and disable ingress/egress gateways to avoid timeout issues on small clusters.

## Run

```bash
ansible-playbook -i hosts_dev playbooks/istio/install.yml --limit vagrant-infra
```

Enable gateways when needed:

```bash
ansible-playbook -i hosts_dev playbooks/istio/install.yml --limit vagrant-infra -e istio_profile=demo -e istio_enable_ingress_gateway=true -e istio_enable_egress_gateway=true
```

## Verify

```bash
vagrant ssh vagrant-infra -c "kubectl -n istio-system get pods"
vagrant ssh vagrant-infra -c "kubectl get ns web --show-labels"
vagrant ssh vagrant-infra -c 'kubectl -n web get pods -o jsonpath="{range .items[*]}{.metadata.name}{\": \"}{range .spec.containers[*]}{.name}{\" \"}{end}{\"\\n\"}{end}"'
```
