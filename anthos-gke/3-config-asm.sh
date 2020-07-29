#!/usr/local/bin/bash
source env.sh
echo "Set firewall rules for sidecar injection..."
echo "Set GCP user account as cluster-admin in K8S ... "
for c in c1 c2; do
  kubectx $c
  kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole=cluster-admin \
  --user="$(gcloud config get-value core/account)"
done

echo "Checking ASM Folder..."
if [ ! -d "$ROOT/asm" ]; then
  echo "asm folder does not exist. Downloading..."
  kpt pkg get https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages.git/asm@release-1.6-asm $ROOT/
else
  echo "asm folder exists. Continue..."
fi

echo "Config C1 Istioctl Operator Parameters...${CLUSTER1}, ${PROJECT_ID}, ${CLUSTER1ZONE}"

kpt cfg set asm gcloud.container.cluster $CLUSTER1
kpt cfg set asm gcloud.compute.location  $CLUSTER1ZONE
kpt cfg set asm gcloud.core.project $PROJECT_ID
kpt cfg set asm gcloud.compute.network $VPC
kpt cfg set asm gcloud.compute.subnetwork $SUBNET1
cp $ROOT/asm/cluster/istio-operator.yaml $ROOT/istio-operator-$CLUSTER1.yaml
kubectx c1
istioctl install --set profile=asm-gcp \
  --set values.global.proxy.tracer=stackdriver \
  --set values.pilot.traceSampling=100 \
  -f $ROOT/asm/cluster/istio-operator.yaml

echo "Config C2 Istioctl Operator Parameters..."
kpt cfg set asm gcloud.container.cluster $CLUSTER2
kpt cfg set asm gcloud.compute.location  $CLUSTER2ZONE
kpt cfg set asm gcloud.core.project $PROJECT_ID
kpt cfg set asm gcloud.compute.network $VPC
kpt cfg set asm gcloud.compute.subnetwork $SUBNET1
cp $ROOT/asm/cluster/istio-operator.yaml $ROOT/istio-operator-$CLUSTER2.yaml
kubectx c2
istioctl install --set profile=asm-gcp \
  --set values.global.proxy.tracer=stackdriver \
  --set values.pilot.traceSampling=100 \
  -f $ROOT/asm/cluster/istio-operator.yaml

echo "Add secret to allow two clusters trust with each other..."
istioctl x create-remote-secret --context=c1 --name=${CLUSTER1} | \
  kubectl apply -f - --context=c2
istioctl x create-remote-secret --context=c2 --name=${CLUSTER2} | \
  kubectl apply -f - --context=c1
