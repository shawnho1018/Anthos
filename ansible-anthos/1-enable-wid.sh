#!/bin/bash
# This sample provides a tutorial for WID, which is constructed as follows:
# 1. Build an SA in GCP
# 2. Build an SA in K8S
# 3. Bind two SAs together and add annotation
# 4. Show a pod started with K8S SA could access gcloud commands

source utility.sh
gcloud container clusters update c1 --workload-pool="${PROJECT_ID}.svc.id.goog" 
gcloud container node-pools update default-pool --workload-metadata=GKE_METADATA --cluster c1
# A terraform sa has been created with project owner authority

kubectl create serviceaccount wid-tester --namespace default

gcloud iam service-accounts add-iam-policy-binding \
	--role roles/iam.workloadIdentityUser \
	--member "serviceAccount:${PROJECT_ID}.svc.id.goog[default/wid-tester]" "terraform@${PROJECT_ID}.iam.gserviceaccount.com"

# add annotation
kubectl annotate serviceaccount -n default wid-tester "iam.gke.io/gcp-service-account=terraform@${PROJECT_ID}.iam.gserviceaccount.com"

# deploy a pod to verify
kubectl run --rm -it \
--generator=run-pod/v1 \
--image google/cloud-sdk:slim \
--serviceaccount wid-tester \
--namespace default \
wid-test
