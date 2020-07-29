#!/bin/bash
source env.sh
gcloud container clusters delete --quiet $CLUSTER1 --zone $CLUSTER1ZONE
gcloud container clusters delete --quiet $CLUSTER2 --zone $CLUSTER2ZONE
gcloud compute networks subnets update $SUBNET1 --region $CLUSTER1REGION --remove-secondary-ranges $CLUSTER1CIDRNAME
gcloud compute networks subnets update $SUBNET2 --region $CLUSTER2REGION --remove-secondary-ranges $CLUSTER2CIDRNAME
gcloud compute networks subnets delete --quiet $SUBNET1 --region $CLUSTER1REGION
gcloud compute networks subnets delete --quiet $SUBNET2 --region $CLUSTER2REGION
gcloud compute networks delete --quiet $VPC
