#!/usr/local/bin/bash
read -p "Enable MTLS policy (y or n)? " option

if [ "$option" = "y" ]; then
   echo "Enforce MTLS for workloads"
   cp demo-files/enable-mtls.yaml config-repo/namespaces/istio-system/
else
   echo "Remove policy from ACM folder"
   rm config-repo/namespaces/istio-system/enable-mtls.yaml
fi
cd config-repo/
git add namespaces/istio-system/
git commit -m "enforce mtls"
git push origin master
cd ../

echo "Use nomos status to verify the status synced"
read -p "press any key to continute when the status is synced..."

pod=$(kubectl get pods -l app=sleep | grep sleep | awk '{print $1}')
kubectl exec -it $pod -- curl http://helloworld.boa.svc.cluster.local:5000/hello
