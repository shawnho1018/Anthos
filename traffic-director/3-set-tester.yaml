#!/bin/bash
echo "produce client VM"
gcloud compute instance-groups managed create client \
	--zone asia-east1-a \
	--size=1 \
	--template="td-shawn-subnet-2-envoy"
