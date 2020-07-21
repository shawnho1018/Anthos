#!/bin/bash
source ./env.sh

### Deploy Workload
gcloud container clusters create $TDCLUSTER --network $NETWORK --subnetwork $GKESUBNET \
  --image-type="COS" --machine-type "n1-standard-1" --enable-stackdriver-kubernetes \
  --enable-ip-alias --service-account terraform@anthos-demo-280104.iam.gserviceaccount.com
gcloud compute instance-groups managed create $IGNAME \
		--zone asia-east1-a \
		--size=2 \
		--template=$TEMPLATENAME

# create health check
gcloud compute health-checks create http $BACKENDCHECK

# create VM backend service
gcloud compute backend-services create $BACKENDNAME\
  --global \
	--load-balancing-scheme=INTERNAL_SELF_MANAGED \
	--health-checks $BACKENDCHECK

gcloud compute backend-services add-backend $BACKENDNAME --instance-group $IGNAME \
	--instance-group-zone asia-east1-a --global

gcloud compute url-maps add-path-matcher $BACKENDURLMAP \
   --default-service $BACKENDNAME \
   --path-matcher-name td-path-matcher

gcloud compute url-maps add-host-rule $BACKENDURLMAP \
   --hosts service-test \
   --path-matcher-name td-path-matcher

# Add Default URLMAP+PROXY
echo '---Add routing rules'
gcloud compute url-maps create $BACKENDURLMAP --default-service $BACKENDNAME

echo '---Add proxies'
gcloud compute target-http-proxies create $BACKENDPROXY \
  --url-map $BACKENDURLMAP


# create proxy forwarding rules
gcloud compute forwarding-rules create $FORWARDRULE \
   --global \
   --load-balancing-scheme=INTERNAL_SELF_MANAGED \
   --address=0.0.0.0 \
   --target-http-proxy=$BACKENDPROXY \
   --ports 80 \
   --network $NETWORK

#################################
### create container services ###
#################################
echo "...Start Container Creation..."
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
echo "########################"
echo "## Load Hybrid Weight ##" 
echo "########################"

gcloud compute url-maps import hello-backend-service-urlmap \
  --source=hello-urlmap.yaml
