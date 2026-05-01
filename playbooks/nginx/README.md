# Commands
Provision VMs:
```bash
ansible-playbook -i hosts_dev playbooks/nginx/install.yml
```

Check status:
```bash
curl http://192.168.56.11:8080/
curl http://192.168.56.12:8080/
curl http://192.168.56.13:8080/
```