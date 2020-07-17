#!/bin/bash

function create-vpc {
  name=$1
  gcloud compute networks create $name --subnet-mode custom

  gcloud beta compute networks subnets create "$name-subnet1" --network $name --range $2 --region asia-east1

  gcloud beta compute networks subnets create "$name-subnet2" --network $name --range $3 --region asia-east1

  gcloud compute firewall-rules create "$name-allow-internal" --network $name --allow tcp:0-65535,udp:0-65535,icmp --source-ranges $4 

  gcloud compute firewall-rules create "$name-allow-ssh-icmp" --network $name --allow tcp:22,icmp
}

function delete-vpc {
  if [ -z $1 ]; then
    echo "please provide vpc name" 1>&2
    return 1
  fi
  gcloud compute firewall-rules delete --quiet "$1-allow-ssh-icmp" 
  gcloud compute firewall-rules delete --quiet "$1-allow-internal"
  gcloud compute firewall-rules delete --quiet $(gcloud compute firewall-rules list | grep "$1" | awk '{ print $1}')  
  gcloud compute networks subnets delete --quiet "$1-subnet1"
  gcloud compute networks subnets delete --quiet "$1-subnet2"
  gcloud compute networks delete --quiet $1
}

function create-gke-cluster {
  if [ -z $1 ]; then
    echo "please provide gke cluster name" 1>&2
    return 1
  fi
  if [ -z $1 ]; then
    echo "please provide the network where the cluster resides" 1>&2
  fi
  gcloud container clusters create $1 --network $2 --image-type="COS" --machine-type "e2-standard-4" --enable-stackdriver-kubernetes --enable-autorepair --enable-autoscaling --max-nodes=5 --min-nodes=2 --enable-cloud-run-alpha --cluster-version=latest 
}

function delete-gke-cluster {
  if [ -z $1 ]; then
    echo "please provide gke cluster name" 1>&2
    return 1
  fi
  gcloud container clusters delete $1 
}

function set_meshid {
  if [ -z $1 ]; then
    echo "please provide gke cluster name" 1>&2
    return 1
  fi
 
  gcloud container clusters update $1 --update-labels=mesh_id=$2
}

