#!/bin/bash

vagrant ssh vagrant-infra -c '
  sudo kubeadm init \
    --apiserver-advertise-address=192.168.56.15 \
    --pod-network-cidr=10.244.0.0/16
'