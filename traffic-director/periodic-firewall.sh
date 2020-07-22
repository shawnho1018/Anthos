while true; do 
  gcloud compute firewall-rules create fw-allow-td-healthchecks \
    --action ALLOW \
    --direction INGRESS \
    --source-ranges 35.191.0.0/16,130.211.0.0/22 \
    --rules tcp \
    --network td
  gcloud compute firewall-rules create fw-allow-default-healthchecks \
    --action ALLOW \
    --direction INGRESS \
    --source-ranges 35.191.0.0/16,130.211.0.0/22 \
    --rules tcp \
    --network default

  sleep 900
done
