#!/bin/bash
echo 'set kubeconfig to admin kubeconfig'
export KUBECONFIG= "kubconfig"
kubectl delete monitoring --all -n kube-system
kubectl delete stackdriver --all -n kube-system
kubectl delete pvc -n kube-system $(kubectl get pvc -n kube-system | grep stackdriver | awk '{print $1}')

echo 'verify there is no pvc in kube-system'
kubectl get pvc -n kube-system
echo 'verify there is no stateful set in kube-system'
kubectl get statefulsets -n kube-system


echo 'Please Power Off/Delete the VMs for master/nodes'

echo 'delete loadbalancer'
gkectl delete loadbalancer --config ./vsphere.yaml --seesaw-group-file ./seesaw-for-gke-admin.yaml
