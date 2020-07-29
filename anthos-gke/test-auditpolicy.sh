#!/usr/local/bin/bash
echo "Apply policy on cluster c1..."
kubectl apply -f demo-files/boa-tls-permissive-policy.yaml --context c1
echo "Check gatekeeper's log for violating on cluster c1..."
kubectl logs -n gatekeeper-system $(kubectl get pod -n gatekeeper-system -l control-plane=controller-manager -o jsonpath={.items..metadata.name}) --context c1 | grep PeerAuthentication | grep "STRICT"
echo "Apply policy on cluster c2..."
kubectl apply -f demo-files/boa-tls-permissive-policy.yaml --context c2
echo "Check gatekeeper's log for violating on cluster c2..."
kubectl logs -n gatekeeper-system $(kubectl get pod -n gatekeeper-system -l control-plane=controller-manager -o jsonpath={.items..metadata.name}) --context c2 | grep PeerAuthentication | grep "STRICT"
