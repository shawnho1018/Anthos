while true; do 
  gcloud compute firewall-rules create fw-allow-td-healthchecks \
    --action ALLOW \
    --direction INGRESS \
    --source-ranges 35.191.0.0/16,130.211.0.0/22 \
    --target-tags td-http-server \
    --rules tcp:80 \
    --network td
  gcloud compute firewall-rules create fw-allow-default-healthchecks \
    --action ALLOW \
    --direction INGRESS \
    --source-ranges 35.191.0.0/16,130.211.0.0/22 \
    --target-tags td-http-server \
    --rules tcp:80 \
    --network default

  sleep 900
done
