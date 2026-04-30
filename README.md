# infra-repo

## Prerequisities
* install vagrant https://developer.hashicorp.com/vagrant/install
* install terraform https://developer.hashicorp.com/terraform/install
* install ansible https://docs.ansible.com/projects/ansible/latest/installation_guide/intro_installation.html
* install docker https://docs.docker.com/engine/install/
* install minikube https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download
* install argocd https://argo-cd.readthedocs.io/en/stable/operator-manual/installation/
* install virtualbox https://www.virtualbox.org/wiki/Downloads

## Ansible playbook running
```bash
docker run --rm -v "$(pwd):/apps/ansible" -w /apps/ansible alpine/ansible:2.20.0 ansible-playbook -i hosts_dev playbooks/nginx/install.yml -l dev
docker run --rm -v "$(pwd):/apps/ansible" -w /apps/ansible alpine/ansible:2.20.0 ansible-playbook -i hosts_dev --syntax-check playbooks/vagrant/install.yml
```