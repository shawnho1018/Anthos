#!/usr/local/bin/bash
while true; do 
  gcloud compute firewall-rules create fw-allow-default-healthchecks \
    --action ALLOW \
    --direction INGRESS \
    --source-ranges 35.191.0.0/16,130.211.0.0/22 \
    --rules tcp \
    --network default
  gcloud compute firewall-rules create default-allow-ssh --allow tcp:22
  sleep 900
done
