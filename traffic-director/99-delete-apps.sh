#!/bin/bash
source env.sh
gcloud compute backend-services --quiet delete $APP1BACKEND --global
gcloud compute backend-services --quiet delete $APP2BACKEND --global
gcloud compute backend-services --quiet delete $APP3BACKEND --global

gcloud compute health-checks --quiet delete $APP1HCHECK
gcloud compute health-checks --quiet delete $APP2HCHECK
gcloud compute health-checks --quiet delete $APP3HCHECK

gcloud compute instance-groups managed --quiet delete $APP2 
kubectx c1
kubectl delete -f trafficdirector_service_sample.yaml
kubectx c2
kubectl delete -f nginx-svc.yaml,nginx.yaml
