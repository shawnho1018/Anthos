#!/bin/bash
source utility.sh

istioctl x create-remote-secret --context=${CTX_C1} --name=${CLUSTER1} | \
  kubectl apply -f - --context=${CTX_C2}
istioctl x create-remote-secret --context=${CTX_C2} --name=${CLUSTER2} | \
  kubectl apply -f - --context=${CTX_C1}
