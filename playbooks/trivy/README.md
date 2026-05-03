# Trivy vulnerability scanning

Install Trivy on `vagrant-infra`, resolve the deployed nginx image from Kubernetes, and scan it for vulnerabilities.

The playbook writes a report to `/var/tmp/trivy-reports` and fails when vulnerabilities at configured severity are found.

## Run

```bash
ansible-playbook -i hosts_dev playbooks/trivy/install.yml --limit vagrant-infra
```

Run with stricter severity (example):

```bash
ansible-playbook -i hosts_dev playbooks/trivy/install.yml --limit vagrant-infra -e trivy_severity=CRITICAL
```

## Verify

```bash
vagrant ssh vagrant-infra -c "trivy --version"
vagrant ssh vagrant-infra -c "ls -lah /var/tmp/trivy-reports"
vagrant ssh vagrant-infra -c "sed -n '1,80p' /var/tmp/trivy-reports/web-nginx-static-image-report.txt"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/CHANGE_ME/.vagrant.d/insecure_private_key vagrant@192.168.56.15 "sed -n '1,60p' /var/tmp/trivy-reports/web-nginx-static-image-report.txt"
```

