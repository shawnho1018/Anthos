#!/bin/bash
kubectl create namespace demo --context $CTX_C1
kubectl label namespace demo istio-injection=enabled --context $CTX_C1
kubectl apply -n demo -f hipster-demo --context $CTX_C1
kubectl get service frontend-external --context $CTX_C1
