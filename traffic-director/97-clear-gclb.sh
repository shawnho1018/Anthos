#!/bin/bash
source env.sh
kubectx c1 
gcloud compute forwarding-rules delete --quiet $ROUTERFORWARDRULE --global
gcloud compute target-http-proxies --quiet delete $ROUTERPROXY --global
gcloud compute url-maps --quiet delete $ROUTERURLMAP
gcloud compute backend-services delete --quiet $ROUTERBACKEND --global
gcloud compute health-checks delete --quiet $ROUTERHCHECK
gcloud compute addresses delete --quiet lb-ipv4-1 --global

kubectl delete -f gateway-proxy.yaml
kubectl delete -f gateway-proxy-svc.yaml 
./98-delete-tdconfig.sh
