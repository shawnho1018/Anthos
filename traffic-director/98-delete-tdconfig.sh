#!/bin/bash
source env.sh
gcloud compute forwarding-rules delete --quiet $NEXTFRULE --global
gcloud compute target-http-proxies delete --quiet $NEXTPROXY
gcloud compute url-maps delete --quiet $NEXTURLMAP
./99-delete-apps.sh
