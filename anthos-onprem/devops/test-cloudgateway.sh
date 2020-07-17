#!/bin/bash
gcloud services enable --project=${PROJECT_ID}  \
connectgateway.googleapis.com \
anthos.googleapis.com \
gkeconnect.googleapis.com \
gkehub.googleapis.com \
cloudresourcemanager.googleapis.com

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member "serviceAccount:terraform@anthos-demo-280104.iam.gserviceaccount.com" \
  --role roles/gkehub.gatewayAdmin

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member "serviceAccount:terraform@anthos-demo-280104.iam.gserviceaccount.com" \
  --role roles/gkehub.viewer

