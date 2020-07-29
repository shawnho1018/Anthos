#!/usr/local/bin/bash
source env.sh
kubectx c1
istioctl manifest generate -f $ROOT/istio-operator-$CLUSTER1.yaml | kubectl delete -f -
kubectl delete ns istio-system
kubectx c2
istioctl manifest generate -f $ROOT/istio-operator-$CLUSTER2.yaml | kubectl delete -f -
kubectl delete ns istio-system
