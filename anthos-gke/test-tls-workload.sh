#!/usr/local/bin/bash
pod=$(kubectl get pods -l app=sleep | grep sleep | awk '{print $1}')
kubectl exec -it $pod -- curl http://helloworld.boa.svc.cluster.local:5000/hello
