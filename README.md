# infra-repo

## Prerequisities
* install vagrant https://developer.hashicorp.com/vagrant/install
* install ansible https://docs.ansible.com/projects/ansible/latest/installation_guide/intro_installation.html
* install minikube https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download
* install virtualbox https://www.virtualbox.org/wiki/Downloads

## Tool description
* ansible playbooks to set up a local kubernetes cluster on vagrant VMs using minikube, deploy nginx to the cluster, install istio service mesh, trivy vulnerability scanner, and configure dns.
* argocd manifests to deploy argocd to the cluster and manage nginx deployment with it
* shell scripts for various cluster configuration tasks
* vagrant and virtualbox configuration files to create and manage VMs
* minikube configuration files to set up kubernetes cluster on vagrant VMs


## Install order
* vagrant playbook
* minikube sh scripts
* istio playbook
* nginx k8s scripts
* trivy playbook
* dns playbook
* argocd scripts