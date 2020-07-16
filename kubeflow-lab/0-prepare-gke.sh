#!/bin/bash

# Install kfctl
wget https://github.com/kubeflow/kfctl/releases/download/v1.0.2/kfctl_v1.0.2-0-ga476281_darwin.tar.gz
tar zxvf kfctl_v1.0.2-0-ga476281_darwin.tar.gz
PATH=$(pwd):$PATH

# Set Environment Variables
export CONFIG_URI="$(pwd)/kfDev-default.yaml"
export CLIENT_ID=[OAuth-ID in GCP]
export CLIENT_SECRET=[OAuth-Secret in GCP]
export KF_NAME="kubeflow-gke"
export BASE_DIR="/Users/shawnho/workspace/Anthos/kubeflow-lab"
export KF_DIR=${BASE_DIR}/${KF_NAME} 
