#!/usr/local/bin/bash
source env.sh
gcloud compute forwarding-rules delete --quiet https-forwarding-rule --global
gcloud compute target-https-proxies delete --quiet https-lb-proxy
gcloud compute url-maps delete --quiet web-map
gcloud compute backend-services delete --quiet my-bes --global
gcloud compute health-checks delete --quiet http-basic-check
NEG_NAME=$(gcloud beta compute network-endpoint-groups list \
    | grep istio | awk '{print $1}')
gcloud compute network-endpoint-groups delete --quiet $NEG_NAME
echo "Static IP will not be auto-deleted. Please remove it by yourself by calling gcloud compute addresses delete --quiet hostname-server-vip"

