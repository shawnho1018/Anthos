#!/bin/bash
source ./env.sh


echo "creating $APP2..."

### Deploy Workload
gcloud compute instance-groups managed create $APP2 \
		--zone $APP2ZONE \
		--size=2 \
		--template=$TEMPLATENAME

# create health check
gcloud compute health-checks create http $APP2HCHECK

# create VM backend service
gcloud compute backend-services create $APP2BACKEND\
  --global \
  --load-balancing-scheme=INTERNAL_SELF_MANAGED \
  --health-checks $APP2HCHECK

gcloud compute backend-services add-backend $APP2BACKEND --instance-group $APP2 \
  --instance-group-zone $APP2ZONE --global

echo "creating $APP1..."
kubectx c1
kubectl apply -f trafficdirector_service_sample.yaml
kubectl scale deployment/app1 --replicas=3

gcloud compute health-checks create http $APP1HCHECK --use-serving-port

# create GKE backend service
gcloud compute backend-services create $APP1BACKEND \
  --global \
  --health-checks $APP1HCHECK \
  --load-balancing-scheme INTERNAL_SELF_MANAGED

while true; do
  NEG_NAME=$(gcloud beta compute network-endpoint-groups list \
    | grep $APP1 | awk '{print $1}')
  if [ -z "${NEG_NAME}" ]; then
    echo "waiting for ${APP1}'s NEG..."
    sleep 2
  else
    break
  fi
done

gcloud compute backend-services add-backend $APP1BACKEND \
    --global \
    --network-endpoint-group "${NEG_NAME}" \
    --network-endpoint-group-zone $APP1ZONE \
    --balancing-mode RATE \
    --max-rate-per-endpoint 5

echo "creating $APP3..."
kubectx c2
kubectl apply -f nginx-svc.yaml
kubectl apply -f nginx.yaml
kubectl scale deployment/nginx --replicas=3

gcloud compute health-checks create http $APP3HCHECK --use-serving-port

# create GKE backend service
gcloud compute backend-services create $APP3BACKEND \
  --global \
  --health-checks $APP3HCHECK \
  --load-balancing-scheme INTERNAL_SELF_MANAGED
while true; do
  NEG_NAME=$(gcloud beta compute network-endpoint-groups list \
    | grep $APP3 | awk '{print $1}')
  if [ -z $"{NEG_NAME}" ]; then
    echo "waiting for ${APP3}'s NEG..."
    sleep 2
  else
    break
  fi
done
gcloud compute backend-services add-backend $APP3BACKEND \
    --global \
    --network-endpoint-group "${NEG_NAME}" \
    --network-endpoint-group-zone $APP3ZONE \
    --balancing-mode RATE \
    --max-rate-per-endpoint 5
kubectx c1
