#!/bin/bash
source ./env.sh

### Deploy Workload
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