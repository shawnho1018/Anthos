#!/usr/local/bin/bash
REPONAME="cloudrun-demo"
PROJECT_ID="anthos-demo-280104"
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")
GCLOUD_ACCOUNT=$(gcloud config get-value account)
CLUSTER="cloudrun"
CLUSTERREGION="asia-east1"
CLUSTERZONE="asia-east1-a"
DOMAINNAME="shawnk8s.com"
SERVICENAME="sample"

gcloud config set run/cluster $CLUSTER
gcloud config set run/cluster_location $CLUSTERZONE
gcloud config set run/platform gke
