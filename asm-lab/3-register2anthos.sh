#!/bin/bash
source utility.sh
for c in c1 c2 
do
  gcloud container hub memberships register gke-$c \
   --project=$PROJECT_ID \
   --gke-cluster=$CLUSTER_LOCATION/$c \
   --service-account-key-file="./anthos-connect-key.json"
done  
