#!/bin/bash

for n in vagrant1 vagrant2 vagrant3 vagrant-dns vagrant-infra vagrant-argo; do
  vagrant ssh "$n" -c '
    set -e
    sudo swapoff -a
    sudo sed -ri "/\sswap\s/s/^/#/" /etc/fstab

    sudo modprobe overlay
    sudo modprobe br_netfilter
    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
    sudo sysctl --system

    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gpg containerd

    sudo mkdir -p /etc/containerd
    containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
    sudo sed -i "s/SystemdCgroup = false/SystemdCgroup = true/" /etc/containerd/config.toml
    sudo systemctl restart containerd
    sudo systemctl enable containerd

    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | \
      sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | \
      sudo tee /etc/apt/sources.list.d/kubernetes.list

    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
  '
done