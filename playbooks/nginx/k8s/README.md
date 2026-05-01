# Nginx deployment to k8s cluster

Commands to deploy nginx to kubernetes cluster.

## Run

```bash
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/CHANGE_NAME/.vagrant.d/insecure_private_key vagrant@192.168.56.15 'kubectl version --client --output=yaml | head -n 5'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/CHANGE_NAME/.vagrant.d/insecure_private_key vagrant@192.168.56.15 'mkdir -p /home/vagrant/infra-repo/playbooks/nginx' && scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/CHANGE_NAME/.vagrant.d/insecure_private_key -r /home/CHANGE_NAME/project/infra-repo/playbooks/nginx/k8s vagrant@192.168.56.15:/home/vagrant/infra-repo/playbooks/nginx/
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/CHANGE_NAME/.vagrant.d/insecure_private_key vagrant@192.168.56.15 'kubectl apply -k /home/vagrant/infra-repo/playbooks/nginx/k8s && kubectl -n web rollout status deployment/nginx-static --timeout=120s && kubectl -n web get pods,svc -o wide'
for ip in 192.168.56.11 192.168.56.12 192.168.56.13; do echo "--- $ip ---"; curl -fsS "http://$ip:30080/" | grep -o 'Nginx is running on port 8080'; done
```