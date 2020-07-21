#!/bin/bash
source ./env.sh

gcloud container clusters create $TDCLUSTER --network $NETWORK --subnetwork $GKESUBNET \
   --image-type="COS" --machine-type "n1-standard-1" --enable-stackdriver-kubernetes --enable-ip-alias
gcloud container clusters get-credentials $TDCLUSTER


# deploy containers
kubectl apply -f trafficdirector_service_sample.yaml

gcloud compute health-checks create http $GKEBACKENDCHECK --use-serving-port

# create GKE backend service
gcloud compute backend-services create $GKEBACKENDNAME \
  --global \
  --health-checks $GKEBACKENDCHECK \
  --load-balancing-scheme INTERNAL_SELF_MANAGED

NEG_NAME=$(gcloud beta compute network-endpoint-groups list \
| grep service-test | awk '{print $1}')
gcloud compute backend-services add-backend $GKEBACKENDNAME \
    --global \
    --network-endpoint-group ${NEG_NAME} \
    --network-endpoint-group-zone asia-east1-a \
    --balancing-mode RATE \
    --max-rate-per-endpoint 5

gcloud compute url-maps create $GKEBACKENDURLMAP \
   --default-service $GKEBACKENDNAME

gcloud compute url-maps add-path-matcher $GKEBACKENDURLMAP \
   --default-service $GKEBACKENDNAME \
   --path-matcher-name td-gke-path-matcher

gcloud compute url-maps add-host-rule $GKEBACKENDURLMAP \
   --hosts service-test \
   --path-matcher-name td-gke-path-matcher

gcloud compute target-http-proxies create $GKEBACKENDPROXY \
  --url-map $GKEBACKENDURLMAP

gcloud compute forwarding-rules create $GKEFORWARDRULE \
	--global \
	--load-balancing-scheme=INTERNAL_SELF_MANAGED \
	--address=10.0.0.2 \
	--target-http-proxy=$GKEBACKENDPROXY \
	--ports 80 \
	--network $NETWORK