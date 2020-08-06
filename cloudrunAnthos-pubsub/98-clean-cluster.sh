#!/usr/local/bin/bash
source env.sh
gcloud container clusters delete --quiet $CLUSTER
