#!/bin/bash
source env.sh
# Add Default URLMAP+PROXY
echo '---Add routing rules'
gcloud compute url-maps create $NEXTURLMAP --default-service $APP2BACKEND

gcloud compute url-maps add-path-matcher $NEXTURLMAP \
   --default-service $APP2BACKEND \
   --path-matcher-name $NEXTPATH

gcloud compute url-maps add-host-rule $NEXTURLMAP \
   --hosts $APP2 \
   --path-matcher-name $NEXTPATH

echo '---Add proxies'
gcloud compute target-http-proxies create $NEXTPROXY \
  --url-map $NEXTURLMAP

# create proxy forwarding rules
gcloud compute forwarding-rules create $NEXTFRULE \
   --global \
   --load-balancing-scheme=INTERNAL_SELF_MANAGED \
   --address=0.0.0.0 \
   --target-http-proxy=$NEXTPROXY \
   --ports 80 \
   --network $NETWORK
