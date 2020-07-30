#!/usr/local/bin/bash
echo "Set CloudRun environment...(Cluster:$CLUSTER1, Region: $CLUSTER1REGION, "
gcloud config set run/cluster $CLUSTER1
gcloud config set run/cluster_location $CLUSTER1REGION

echo "Convert CloudRun into internal laodbalancer..."
echo "Change istio-ingress into internal ip..."
kubectl -n gke-system patch svc istio-ingress -p \
    '{"metadata":{"annotations":{"cloud.google.com/load-balancer-type":"Internal"}}}'

gcloud run deploy sample \
  --image gcr.io/knative-samples/simple-api \
  --cluster taiwan-1 \
  --cluster-location asia-east1-a \
  --platform gke


gcloud pubsub topics create swagger-test
gcloud projects add-iam-policy-binding $PROJECT_ID \
     --member=serviceAccount:service-PROJECT-NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com \
     --role=roles/iam.serviceAccountTokenCreator


