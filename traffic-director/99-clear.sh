#!/bin/bash
source env.sh
gcloud compute forwarding-rules delete --quiet $FORWARDRULE --global
gcloud compute forwarding-rules delete --quiet $GKEFORWARDRULE --global
gcloud compute target-http-proxies --quiet delete $BACKENDPROXY
gcloud compute target-http-proxies --quiet delete $GKEBACKENDPROXY
gcloud compute url-maps delete --quiet $BACKENDURLMAP
gcloud compute backend-services --quiet delete $BACKENDNAME --global
gcloud compute health-checks --quiet delete http $BACKENDCHECK
gcloud compute instance-groups managed --quiet delete $IGNAME

gcloud compute url-maps --quiet delete $GKEBACKENDURLMAP
gcloud compute backend-services --quiet delete $GKEBACKENDNAME --global
gcloud compute health-checks --quiet delete http $GKEBACKENDCHECK

kubectl delete -f trafficdirector_service_sample.yaml
kubectl delete -f trafficdirector_client_sample.yaml

