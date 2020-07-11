#!/bin/bash

RESOURCES_PREFIX="td-observability-demo"
ZONE="us-central1-a"

gcloud compute health-checks create http ${RESOURCES_PREFIX}-health-check

gcloud compute backend-services create ${RESOURCES_PREFIX}-service \
    --global \
    --load-balancing-scheme=INTERNAL_SELF_MANAGED \
    --health-checks ${RESOURCES_PREFIX}-health-check

gcloud compute backend-services add-backend ${RESOURCES_PREFIX}-service \
    --instance-group td-observability-service-vm-mig \
    --instance-group-zone ${ZONE} \
    --global

gcloud compute url-maps create ${RESOURCES_PREFIX}-url-map \
   --default-service ${RESOURCES_PREFIX}-service

gcloud compute target-http-proxies create ${RESOURCES_PREFIX}-proxy \
   --url-map ${RESOURCES_PREFIX}-url-map

gcloud compute forwarding-rules create ${RESOURCES_PREFIX}-forwarding-rule \
   --global \
   --load-balancing-scheme=INTERNAL_SELF_MANAGED \
   --address=0.0.0.0 \
   --target-http-proxy=${RESOURCES_PREFIX}-proxy \
   --ports 80 \
   --network default
