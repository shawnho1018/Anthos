#!/bin/bash
kubectx c2
kubectl apply -f trafficdirector_client_sample.yaml
while true; do
  status=$(kubectl get pods | grep busybox | awk '{print $3}')
  if [[ "$status" == "Running" ]]; then
    break
  fi
  sleep 2
  echo "pod status=$status: still waiting for pod to be ready"
done

BUSYBOX_POD=$(kubectl get po -l run=client -o=jsonpath='{.items[0].metadata.name}')

echo 'Pod -> VM'
TEST_CMD="wget -q --header 'Host: next-hello' -O - 10.0.0.1; echo"
kubectl exec -it $BUSYBOX_POD -c busybox -- /bin/sh -c "$TEST_CMD"
