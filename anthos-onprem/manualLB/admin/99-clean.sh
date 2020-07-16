#!/bin/bash
echo 'set kubeconfig to admin kubeconfig'
export KUBECONFIG=~/.kube/config
kubectl delete monitoring --all -n kube-system
kubectl delete stackdriver --all -n kube-system
kubectl delete pvc $(kubectl get pvc -n kube-system | grep stackdriver | awk '{print $1}')

echo 'verify there is no pvc in kube-system'
kubectl get pvc -n kube-system
echo 'verify there is no stateful set in kube-system'
kubectl get statefulsets -n kube-system


echo 'Please Power Off/Delete the VMs for master/nodes'
