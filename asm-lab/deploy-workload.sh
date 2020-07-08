#!/bin/bash
for CTX in ${CTX_C1} ${CTX_C2}
  do
    kubectl create --context=${CTX} namespace sample
    kubectl label --context=${CTX} namespace sample \
      istio-injection=enabled
    kubectl create --context=${CTX} \
      -f istio-1.6.4-asm.9/samples/helloworld/helloworld.yaml \
      -l app=helloworld -n sample
  done
  kubectl apply -f istio-1.6.4-asm.9/samples/helloworld/helloworld.yaml -l app=helloworld -l version=v1 -n sample --context ${CTX_C1}
  kubectl apply -f istio-1.6.4-asm.9/samples/helloworld/helloworld.yaml -l app=helloworld -l version=v2 -n sample --context ${CTX_C2}
