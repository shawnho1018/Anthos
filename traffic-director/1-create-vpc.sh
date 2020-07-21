#!/bin/bash
# Deploy VPC
gcloud compute networks create $NETWORK --subnet-mode custom
gcloud beta compute networks subnets create $GKESUBNET --network $NETWORK --range "192.168.0.0/24" --region asia-east1
gcloud beta compute networks subnets create $SUBNET --network $NETWORK --range "192.168.1.0/24" --region asia-east1
# [todo] Create Cloud NAT to allow subnets to go to internet
