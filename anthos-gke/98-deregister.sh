#!/usr/local/bin/bash
source env.sh
echo "DeRegister GKE from Anthos"
gcloud container hub memberships unregister $CLUSTER1ZONE-$CLUSTER1 --gke-cluster $CLUSTER1ZONE/$CLUSTER1
gcloud container hub memberships unregister $CLUSTER2ZONE-$CLUSTER2 --gke-cluster $CLUSTER2ZONE/$CLUSTER2

