#!/bin/bash
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

# Command to send a request to service-test and output server response headers.
TEST_CMD="wget -S --spider service-test; echo"

# Execute the test command on the pod.
#kubectl exec -it $BUSYBOX_POD -c busybox -- /bin/sh -c "$TEST_CMD"

echo 'Pod -> Pod'
#TEST_CMD="wget -q --header 'Host: service-test' -O - 10.0.0.2; echo"
#kubectl exec -it $BUSYBOX_POD -c busybox -- /bin/sh -c "$TEST_CMD"

echo 'Pod -> VM'
TEST_CMD="wget -q --header 'Host: service-test' -O - 10.0.0.1; echo"
kubectl exec -it $BUSYBOX_POD -c busybox -- /bin/sh -c "$TEST_CMD"
