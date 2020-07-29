#!/bin/bash
# This sample provides a tutorial for WID, which is constructed as follows:
# 1. Build an SA in GCP
# 2. Build an SA in K8S
# 3. Bind two SAs together and add annotation
# 4. Show a pod started with K8S SA could access gcloud commands

source env.sh
CONTEXT_C1="c1"
CONTEXT_C2="c2"
for c in $CONTEXT_C1 $CONTEXT_C2
  do
    # A terraform sa has been created with project owner authority
    kubectl create serviceaccount wid-tester --namespace default --context $c
  done

# link GSID to KSID
echo "Link GSID to KSID..."
gcloud iam service-accounts add-iam-policy-binding \
   --role roles/iam.workloadIdentityUser \
   --member "serviceAccount:${PROJECT_ID}.svc.id.goog[default/wid-tester]" "terraform@${PROJECT_ID}.iam.gserviceaccount.com"

for c in $CONTEXT_C1 $CONTEXT_C2; do
    # add annotation
    kubectl annotate serviceaccount -n default wid-tester "iam.gke.io/gcp-service-account=terraform@${PROJECT_ID}.iam.gserviceaccount.com"
done

echo "Register GKE to Anthos..."
gcloud container hub memberships register $CLUSTER1ZONE-$CLUSTER1 --project=$PROJECT_ID \
  --gke-cluster=$CLUSTER1ZONE/$CLUSTER1 \
  --service-account-key-file="$KEYS/anthos-connect-sa.key"
gcloud container hub memberships register $CLUSTER2ZONE-$CLUSTER2 --project=$PROJECT_ID \
  --gke-cluster=$CLUSTER2ZONE/$CLUSTER2 \
  --service-account-key-file="$KEYS/anthos-connect-sa.key"
