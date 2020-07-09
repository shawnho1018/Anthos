#!/bin/bash
# Install ASM 1.6 on clusters

for c in $CLUSTER1 $CLUSTER2
  do 
    kpt cfg set asm gcloud.compute.location ${CLUSTER_LOCATION}
    kpt cfg set asm gcloud.container.cluster $c
    kpt cfg set asm gcloud.compute.network asm-c1
    kpt cfg set asm gcloud.compute.subnetwork asm-c1-subnet
    istioctl install -f asm/cluster/istio-operator.yaml --context gke_${PROJECT_ID}_${CLUSTER_LOCATION}_${c}
  done


