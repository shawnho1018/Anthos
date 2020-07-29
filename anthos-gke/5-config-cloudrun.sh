#!/usr/local/bin/bash
gcloud config set run/cluster $CLUSTER1
gcloud config set run/cluster_location $CLUSTER1REGION
gcloud pubsub topics create swagger-test
gcloud projects add-iam-policy-binding $PROJECT_ID \
     --member=serviceAccount:service-PROJECT-NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com \
     --role=roles/iam.serviceAccountTokenCreator
