#!/bin/bash
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
    cloudresourcemanager.googleapis.com

for c in c1 c2
do
  # add mesh-id
  gcloud container clusters update $c --update-labels=mesh_id=${MESH_ID}
  # enable workload-identity
  gcloud container clusters update $c --workload-pool=${WORKLOAD_POOL}
  # enable stackdriver
  gcloud container clusters update $c --enable-stackdriver-kubernetes
done

