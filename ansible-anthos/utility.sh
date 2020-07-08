#!/bin/bash

# create vpc
function create_vpc {
  name=$1
  gcloud compute networks create $name --subnet-mode custom

  gcloud beta compute networks subnets create "$name-subnet1" --network $name --range $2 --region asia-east1

  gcloud beta compute networks subnets create "$name-subnet2" --network $name --range $3 --region asia-east1

  gcloud compute firewall-rules create "$name-allow-internal" --network $name --allow tcp:0-65535,udp:0-65535,icmp --source-ranges $4 

  gcloud compute firewall-rules create "$name-allow-ssh-icmp" --network $name --allow tcp:22,icmp
}

function delete_vpc {
  gcloud compute firewall-rules delete --quiet "$1-allow-ssh-icmp" 
  gcloud compute firewall-rules delete --quiet "$1-allow-internal"
  gcloud compute firewall-rules delete --quiet $(gcloud compute firewall-rules list | grep "$1" | awk '{ print $1}')  
  gcloud compute networks subnets delete --quiet "$1-subnet1"
  gcloud compute networks subnets delete --quiet "$1-subnet2"
  gcloud compute networks delete --quiet $1
}

function create_gke {
  gcloud container clusters create $1 --network $2 --subnetwork "$2-subnet1" --image-type="COS" --machine-type "e2-standard-4" --enable-stackdriver-kubernetes --enable-autorepair --enable-autoscaling --max-nodes=5 --min-nodes=2 --enable-cloud-run-alpha --cluster-version=latest 
}

function delete_gke {
  gcloud container clusters delete $1 
}

function set_meshid {
  gcloud container clusters update $1 --update-labels=mesh_id=$2
}

### export environmental variables
export PROJECT_ID="anthos-demo-280104"
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")
export CLUSTER1="c1"
export CLUSTER2="c2"
export WORKLOAD_POOL="${PROJECT_ID}.svc.id.goog"
export CLUSTER_LOCATION="asia-east1-a"
export MESH_ID="proj-${PROJECT_ID}"
export CTX_C1="gke_${PROJECT_ID}_${CLUSTER_LOCATION}_${CLUSTER1}"
export CTX_C2="gke_${PROJECT_ID}_${CLUSTER_LOCATION}_${CLUSTER2}"

