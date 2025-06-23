helm install cilium cilium/cilium \
  --version 1.17.5 \
  --namespace kube-system \
  --set operator.replicas=1