#!/usr/local/bin/bash
read -p "Apply or remove audit policy (a or r)? " option

if [ "$option" = "a" ]; then
   echo "Copy policy to ACM folder"
   cp demo-files/constraint-audit.yaml config-repo/cluster/
else
   echo "Remove policy from ACM folder"
   rm config-repo/cluster/constraint-audit.yaml
fi
cd config-repo/
git add cluster/
git commit -m "change policy"
git push origin master
cd ../

echo "Use nomos status to verify the status synced"
read -p "press any key to continute when the status is synced..."

echo "Apply policy on cluster c1..."
kubectl apply -f demo-files/boa-tls-permissive-policy.yaml --context c1
#echo "Check gatekeeper's log for violating on cluster c1..."
#kubectl logs -n gatekeeper-system $(kubectl get pod -n gatekeeper-system -l control-plane=controller-manager -o jsonpath={.items..metadata.name}) --context c1 | grep PeerAuthentication | grep "STRICT"
echo "Apply policy on cluster c2..."
kubectl apply -f demo-files/boa-tls-permissive-policy.yaml --context c2
#echo "Check gatekeeper's log for violating on cluster c2..."
#kubectl logs -n gatekeeper-system $(kubectl get pod -n gatekeeper-system -l control-plane=controller-manager -o jsonpath={.items..metadata.name}) --context c2 | grep PeerAuthentication | grep "STRICT"

read -p "Press any key to reset the demo..." myinput
echo "Delete policy for next demo"
kubectl delete -f demo-files/boa-tls-permissive-policy.yaml --context c1
kubectl delete -f demo-files/boa-tls-permissive-policy.yaml --context c2

