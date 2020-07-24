#!/bin/bash
source env.sh
echo "setting VPC...."
gcloud compute networks create $NETWORK --subnet-mode custom --bgp-routing-mode=global
gcloud beta compute networks subnets create $SUBNET1 --network $NETWORK --range "192.168.0.0/24" --region $APP1REGION
gcloud beta compute networks subnets create $SUBNET2 --network $NETWORK --range "192.168.1.0/24" --region $APP2REGION
gcloud beta compute networks subnets create $SUBNET3 --network $NETWORK --range "192.168.2.0/24" --region $APP3REGION

echo "...create kubernetes cluster in $APP1LOCATION"
gcloud container clusters create $CLUSTER1 --network $NETWORK --subnetwork $SUBNET1 \
   --image-type="COS" --machine-type "n1-standard-1" --enable-stackdriver-kubernetes \
   --enable-ip-alias --zone $APP1ZONE --service-account terraform@anthos-demo-280104.iam.gserviceaccount.com
gcloud container clusters get-credentials $CLUSTER1 --zone $APP1ZONE

echo "...create kubernetes cluster in $APP3LOCATION"
gcloud container clusters create $CLUSTER2 --network $NETWORK --subnetwork $SUBNET3 \
   --image-type="COS" --machine-type "n1-standard-1" --enable-stackdriver-kubernetes \
   --enable-ip-alias --zone $APP3ZONE --service-account terraform@anthos-demo-280104.iam.gserviceaccount.com
gcloud container clusters get-credentials $CLUSTER2 --zone $APP3ZONE

kubectx c1=gke_anthos-demo-280104_asia-northeast1-a_next-cluster1
kubectx c2=gke_anthos-demo-280104_asia-northeast1-a_next-cluster2
