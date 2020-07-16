#!/bin/bash

# Set Environment Variables
export CONFIG_URI="https://raw.githubusercontent.com/kubeflow/manifests/v1.0-branch/kfdef/kfctl_k8s_istio.v1.0.2.yaml"
export KF_NAME="kubeflow-onprem"
export BASE_DIR="/home/shawnho/Anthos/kubeflow-lab"
export KF_DIR=${BASE_DIR}/${KF_NAME} 
# Create your Kubeflow configurations:
mkdir -p ${KF_DIR}
cd ${KF_DIR}
kfctl build -V -f ${CONFIG_URI}
export CONFIG_FILE=${KF_DIR}/kfctl_k8s_istio.v1.0.2.yaml
