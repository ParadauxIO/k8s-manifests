#!/bin/bash
echo "This script will delete all namespaces except kube-system, default, kube-public, and kube-node-lease."
read -p "Are you sure you want to continue? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
  echo "Operation cancelled."
  exit 1
fi

echo "Wiping cluster (keeping software)..."
sudo kubeadm reset --force && \
sudo rm -rf /etc/kubernetes/ ~/.kube/ /var/lib/etcd/ /var/lib/cni/ /etc/cni/net.d/* && \
sudo crictl rm $(sudo crictl ps -aq) 2>/dev/null || true && \
sudo crictl rmp $(sudo crictl pods -q) 2>/dev/null || true && \
sudo ip link delete cilium_host 2>/dev/null || true && \
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X && \
sudo systemctl restart containerd kubelet && \
echo "Cluster wiped - ready for fresh init!"