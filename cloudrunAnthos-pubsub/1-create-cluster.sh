#!/usr/local/bin/bash
source env.sh
echo "Creating kubernetes cluster...$CLUSTER using cloud build"
gcloud --project $PROJECT_ID builds submit --machine-type n1-highcpu-8 --config cloudbuild-infra.yaml --substitutions _CLUSTER_NAME=$CLUSTER,_CLUSTER_LOCATION=$CLUSTERZONE
gcloud container clusters get-credentials $CLUSTER
