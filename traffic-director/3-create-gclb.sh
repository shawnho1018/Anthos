#!/bin/bash
source env.sh
kubectl apply -f gateway-proxy-svc.yaml
kubectl apply -f gateway-proxy.yaml


echo "...create ip for GCLB"
gcloud compute addresses create lb-ipv4-1 \
    --ip-version=IPV4 \
    --global
echo "global IP address is: "
gcloud compute addresses describe lb-ipv4-1 \
    --format="get(address)" \
    --global

gcloud compute health-checks create http $ROUTERHCHECK \
    --port 80

gcloud compute backend-services create $ROUTERBACKEND \
    --protocol HTTP \
    --health-checks $ROUTERHCHECK \
    --global

NEG_NAME=$(gcloud beta compute network-endpoint-groups list \
| grep gateway-proxy | awk '{print $1}')
        
gcloud compute backend-services add-backend $ROUTERBACKEND \
    --global \
    --network-endpoint-group ${NEG_NAME} \
    --network-endpoint-group-zone asia-east1-a \
    --balancing-mode RATE \
    --max-rate-per-endpoint 5

gcloud compute url-maps create  $ROUTERURLMAP\
    --default-service $ROUTERBACKEND

gcloud compute target-http-proxies create $ROUTERPROXY \
    --url-map $ROUTERURLMAP
gcloud compute forwarding-rules create $ROUTERFORWARDRULE \
    --address=lb-ipv4-1\
    --global \
    --target-http-proxy=$ROUTERPROXY \
    --ports=80
            
