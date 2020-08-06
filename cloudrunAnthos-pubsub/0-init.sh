#!/usr/local/bin/bash
# This script only needs to be run once.
# It is mainly for enabling services and add role-bindings. 
# It is also used to create static ip address and ssl certificate for GCLB

source env.sh
echo "Build docker image for two target images: helloworld and pubsub"
gcloud build submit cloudrun-demo/helloworld/ --tag gcr.io/$PROJECT_ID/helloworld
gcloud build submit cloudrun-demo/pubsub/ --tag gcr.io/$PROJECT_ID/pubsub

echo "initialize pub/sub services..."
gcloud services enable pubsub.googleapis.com
gcloud projects add-iam-policy-binding $PROJECT_ID \
     --member=serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-pubsub.iam.gserviceaccount.com \
     --role=roles/iam.serviceAccountTokenCreator
echo "Create a static ip for GCLB..."
gcloud compute addresses create hostname-server-vip \
  --ip-version=IPV4 \
  --global
gcloud compute ssl-certificates create sample-cert \
  --description="cert for ${SERVICENAME}.default.${DOMAINNAME}" \
  --domains="${SERVICENAME}.default.${DOMAINNAME}" \
  --global
IP=$(gcloud compute addresses describe hostname-server-vip --global | grep "address:" | awk '{print $2}')
echo "----------------------"
echo "Please add DNS A record entry for $IP and $SERVICENAME.default.$DOMAINNAME"
