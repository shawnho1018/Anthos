gcloud compute instance-groups managed create client \
	--zone asia-east1-a \
	--size=1 \
	--template="td-envoy-template"
gcloud compute instance-groups managed create backend-$1 \
  --zone asia-east1-a \
  --size=2 \
  --template=$1

gcloud compute health-checks create http td-vm-hc

#gcloud compute firewall-rules create fw-allow-hc --action ALLOW --direction INGRESS \
#	--source-ranges 35.191.0.0/16,130.211.0.0/22 \
#	--target-tags http-td-tag,http-server,https-server \
#	--rules tcp
gcloud compute backend-services create td-vm-svc --global \
	--load-balancing-scheme=INTERNAL_SELF_MANAGED \
	--health-checks td-vm-hc
gcloud compute backend-services add-backend td-vm-svc --instance-group backend-$1 \
	--instance-group-zone asia-east1-a --global

## Add routing rules
gcloud compute url-maps create td-vm-urlmap --default-service td-vm-svc
gcloud compute url-maps add-path-matcher td-vm-urlmap --default-service td-vm-svc --path-matcher-name td-vm-path-matcher
gcloud compute url-maps add-host-rule td-vm-urlmap --hosts hello-world.example.com \
	--path-matcher-name td-vm-path-matcher

# create http proxy
gcloud compute target-http-proxies create td-vm-proxy --url-map td-vm-urlmap

# create proxy forwarding rules
gcloud compute forwarding-rules create td-vm-forwarding-rule \
   --global \
   --load-balancing-scheme=INTERNAL_SELF_MANAGED \
   --address=10.0.0.1 \
   --target-http-proxy=td-vm-proxy \
   --ports 80 \
   --network default
