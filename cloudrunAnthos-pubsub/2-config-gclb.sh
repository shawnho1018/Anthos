#!/usr/local/bin/bash
source env.sh
echo "Map default domain to custom domain in Cloudrun..."
kubectl patch configmap config-domain --namespace knative-serving --patch '{"data": {"example.com": null, "'${DOMAINNAME}'": ""}}'

echo "Change istio-ingress into internal ip..."
kubectl -n gke-system patch svc istio-ingress -p \
    '{"metadata":{"annotations":{"cloud.google.com/load-balancer-type":"Internal"}}}'

echo "Deploy helloworld to test on gclb..."
gcloud run deploy ${SERVICENAME} \
   --image gcr.io/$PROJECT_ID/helloworld

echo "Setup zonal NEG..."
kubectl annotate --overwrite --namespace gke-system service istio-ingress 'cloud.google.com/neg={"exposed_ports": {"80":{}}}'

gcloud compute health-checks create tcp http-basic-check \
  --use-serving-port

echo "setup backend-services..."
gcloud compute backend-services create my-bes \
  --protocol HTTP \
  --health-checks http-basic-check \
  --custom-request-header="Host: ${SERVICENAME}.default.${DOMAINNAME}" \
  --global

while true; do
  NEG_NAME=$(gcloud beta compute network-endpoint-groups list \
    | grep istio | awk '{print $1}')
  if [ -z $"{NEG_NAME}" ]; then
    echo "waiting for ${APP3}'s NEG..."
    sleep 2
  else
    break
  fi
done
echo "Connect backend service to standard NEG..."
gcloud compute backend-services add-backend my-bes \
  --global \
  --balancing-mode RATE \
  --max-rate-per-endpoint 5 \
  --network-endpoint-group "${NEG_NAME}" \
  --network-endpoint-group-zone $CLUSTERZONE

gcloud compute url-maps create web-map \
  --default-service my-bes

gcloud compute target-https-proxies create https-lb-proxy \
  --url-map web-map \
  --global-ssl-certificates \
  --ssl-certificates sample-cert

gcloud compute forwarding-rules create https-forwarding-rule \
  --address=hostname-server-vip \
  --global \
  --target-https-proxy=https-lb-proxy \
  --ports=443

echo "Please check gcloud console and wait until health check find the backend service healthy. \
      This may take from 8-12 minutes...\
      Once it becomes healthy, using curl https://$SERVICENAME.default.$DOMAINNAME to check \
      if GCLB and CloudRun has been successfully integrated. " 
