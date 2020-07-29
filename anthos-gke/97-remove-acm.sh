#!/bin/bash
source env.sh
kubectx c1
kubectl delete -f "$ACM/$CLUSTER1.yaml"
kubectl delete -f "$ACM/config-management-operator.yaml"

kubectx c2
kubectl delete -f "$ACM/$CLUSTER2.yaml"
kubectl delete -f "$ACM/config-management-operator.yaml"
