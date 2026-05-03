# Commands
Provision VMs:
```bash
ansible-playbook -i hosts_dev playbooks/vagrant/install.yml
```

Check status go to directory .vagrant-ubuntu24 and run:
```bash
vagrant ssh vagrant2 -c "hostname && ip -4 a"
ping -c 2 192.168.56.12
```