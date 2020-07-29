#!/bin/bash
source ./env.sh
gcloud services enable \
    container.googleapis.com \
    compute.googleapis.com \
    monitoring.googleapis.com \
    logging.googleapis.com \
    cloudtrace.googleapis.com \
    meshca.googleapis.com \
    meshtelemetry.googleapis.com \
    meshconfig.googleapis.com \
    iamcredentials.googleapis.com \
    anthos.googleapis.com \
    gkeconnect.googleapis.com \
    gkehub.googleapis.com \
    cloudresourcemanager.googleapis.com \
    sourcerepo.googleapis.com

CLUSTER1PODCIDR="10.56.0.0/14"
CLUSTER1SVCCIDR="10.120.0.0/20"
CLUSTER2PODCIDR="10.60.0.0/14"
CLUSTER2SVCCIDR="10.121.0.0/20"

# create vpc
#echo "Setting VPC..."
#gcloud compute networks create $VPC --subnet-mode custom --bgp-routing-mode=global
#gcloud beta compute networks subnets create $SUBNET1 --network $VPC --range "192.168.10.0/24" --region $CLUSTER1REGION
echo "*** name: $CLUSTER1CIDRNAME = $CLUSTER1PODCIDR *** "
gcloud compute networks subnets update $SUBNET1 \
    --region ${CLUSTER1REGION} \
    --add-secondary-ranges ${CLUSTER1CIDRNAME}=${CLUSTER1PODCIDR} 

#gcloud beta compute networks subnets create $SUBNET2 --network $VPC --range "192.168.11.0/24" --region $CLUSTER2REGION
gcloud compute networks subnets update $SUBNET2 \
    --region ${CLUSTER2REGION} \
    --add-secondary-ranges ${CLUSTER2CIDRNAME}=${CLUSTER2PODCIDR} 

# create gke
echo "Create GKE Cluster...with stackdriver, workload-identity, cloudrun"
gcloud beta container clusters create $CLUSTER1 \
  --network $VPC --subnetwork "$SUBNET1" \
  --enable-ip-alias \
  --image-type="COS" \
  --machine-type "e2-standard-4" \
  --num-nodes=4 \
  --workload-pool="$PROJECT_ID.svc.id.goog" \
  --enable-stackdriver-kubernetes \
  --release-channel=regular \
  --zone=$CLUSTER1ZONE \
  --addons=HttpLoadBalancing,CloudRun,HorizontalPodAutoscaling \
  --services-ipv4-cidr=${CLUSTER1SVCCIDR} \
  --cluster-secondary-range-name=${CLUSTER1CIDRNAME} \
  --labels mesh_id=${MESH_ID} 

gcloud beta container clusters create $CLUSTER2 \
  --network $VPC --subnetwork "$SUBNET2" \
  --enable-ip-alias \
  --image-type="COS" \
  --machine-type "e2-standard-4" \
  --num-nodes=4 \
  --workload-pool="$PROJECT_ID.svc.id.goog" \
  --enable-stackdriver-kubernetes \
  --release-channel=regular \
  --zone=$CLUSTER2ZONE \
  --addons=HttpLoadBalancing,CloudRun,HorizontalPodAutoscaling \
  --labels mesh_id=${MESH_ID} \
  --services-ipv4-cidr=${CLUSTER2SVCCIDR} \
  --cluster-secondary-range-name=${CLUSTER2CIDRNAME}

gcloud container clusters get-credentials $CLUSTER1 --zone $CLUSTER1ZONE
gcloud container clusters get-credentials $CLUSTER2 --zone $CLUSTER2ZONE
kubectx c1=gke_${PROJECT_ID}_${CLUSTER1ZONE}_$CLUSTER1
kubectx c2=gke_${PROJECT_ID}_${CLUSTER2ZONE}_$CLUSTER2
