# Minikube on Vagrant

Commands to install kubernetes cluster on Vagrant VM using minikube.

## Run

After you create VMs using vagrant, run the following commands to prepare and configure kubernetes cluster:

```bash
cd /playbooks/vagrant/.vagrant-ubuntu24
../../prepare-vms.sh
../../configure-node.sh
../../configure-kube.sh
```

Get join command:
```bash
vagrant ssh vagrant-infra -c "sudo kubeadm token create --print-join-command"
```

Output paste on worker node:
```bash
vagrant ssh vagrant1 -c "sudo <PASTE_JOIN_COMMAND_HERE>"
vagrant ssh vagrant2 -c "sudo <PASTE_JOIN_COMMAND_HERE>"
vagrant ssh vagrant3 -c "sudo <PASTE_JOIN_COMMAND_HERE>"
vagrant ssh vagrant-dns -c "sudo <PASTE_JOIN_COMMAND_HERE>"
```


## Verify

```bash
vagrant ssh vagrant1 -c "kubectl get nodes -o wide"
```

