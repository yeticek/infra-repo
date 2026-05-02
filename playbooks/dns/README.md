# DNS setup

Configure `vagrant-dns` to serve `nginx-test.io.sk` and return all three nginx node IPs.

## Run

```bash
ansible-playbook -i hosts_dev playbooks/dns/install.yml --limit vagrant-dns
```

## Verify

```bash
vagrant ssh vagrant-dns -c "dig +short @192.168.56.14 nginx-test.io.sk"
for ip in 192.168.56.11 192.168.56.12 192.168.56.13; do echo "$ip"; done
vagrant ssh vagrant1 -c "dig +short @192.168.56.14 nginx-test.io.sk"
```

Optional HTTP check via DNS (when client resolver points to `192.168.56.14`):

```bash
curl -fsS http://nginx-test.io.sk:30080/ | head -n 1
```

