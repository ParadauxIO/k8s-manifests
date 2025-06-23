# Setup a Kubernetes master node with kubeadm
sudo kubeadm init

# Setup kubeconfig for the current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Allow scheduling pods on the master node
kubectl taint nodes srv.paradaux.io node-role.kubernetes.io/control-plane-

kubectl apply -f 01-local-path-provisioner.yml

helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium \
     --version 1.17.5 \
     --namespace kube-system \
     --set kubeProxyReplacement=true \
     --set kubeProxyReplacementMode=strict \
     --set k8sServiceHost=51.178.64.202 \
     --set k8sServicePort=6443 \
     --set dnsProxy.enabled=true \
     --set enableRemoteNodeIdentity=true \
     --set enableIPv4Masquerade=true \
     --set operator.replicas=1
     --wait

kubectl apply -f 03-cert-manager.yml
kubectl apply -f 04-cluster-issuer.yml
kubectl apply -f 05-nginx.yml
kubectl apply -f 06-whoami.yml
kubectl apply -f 07-cans.ie.yml

