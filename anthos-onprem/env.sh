# This function is to define environment variables
#!/bin/bash

#GCP
PROJECT_ID="anthos-demo-280104"
gcloud config set project $PROJECT_ID
gcloud config set compute/zone asia-east1-a

#File architecture
export ROOT=$(pwd) 
export SEESAW="$ROOT/seesaw"
export MANUALLB="$ROOT/manualLB"
export KEYS="$ROOT/keys"
export ONPREMCLUSTER="on-prem1"
export CLUSTER1="gcp"
export PROJECT_DIR=$(pwd)/istio-1.6.4-asm.9
export GCLOUD_ACCOUNT="shawn.ho1976@gmail.com"
export CLUSTER1="gcp"
export WORKLOAD_POOL="${PROJECT_ID}.svc.id.goog"
export CLUSTER_LOCATION="asia-east1-a"
export ACM="$ROOT/acm"
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")
export GCLOUD_ACCOUNT=$(gcloud config get-value account)
#########################
# Functions
########################

# create admin-cluster
function create-admin-cluster {
   if [ -z $1 ]; then
     echo "Please provide either manuallb or seesaw" 1>&2
     return 1
   fi
   if [ $1 == "seesaw" ]; then
     echo "creating admin cluster using seesaw"
     if [ ! -f "$SEESAW/admin/seesaw-for-gke-adm.yaml" ]; then
       gkectl create loadbalancer --config $SEESAW/admin/admin-cluster.yaml
       sleep 10s
     else
       echo "Seesaw load balancer exists...skip creation"
     fi
     gkectl create admin --config $SEESAW/admin/admin-cluster.yaml
     echo "copying kubeconfig into keys folder"
     cp ./kubeconfig keys/
     return 0
   fi
   if [ $1 == "manualLB" ]; then
     echo "creating admin cluster using manualLB"
     gkectl create admin --config $MANUALLB/admin/admin-cluster.yaml
     return 0
   fi
   echo "Only support seesaw and manualLB for now" 1>&2
   return 1
     
}
#create user-cluster
function create-user-cluster {
   if [ -z $1 ]; then
     echo "Please provide either manuallb or seesaw" 1>&2
     return 1
   fi
   if [ $1 == "seesaw" ]; then
     echo "creating cluster using seesaw"
     if [ ! -f "$SEESAW/user/seesaw-for-on-prem1.yaml" ]; then
       gkectl create loadbalancer --config $SEESAW/user/user-cluster.yaml --kubeconfig $KEYS/kubeconfig
       sleep 10s
     else
       echo "Seesaw load balancer exists...skip creation"
     fi
     gkectl create cluster --config $SEESAW/user/user-cluster.yaml --kubeconfig $KEYS/kubeconfig
     return 0
   fi
   if [ $1 == "manualLB" ]; then
     echo "creating cluster using manualLB"
     gkectl create cluster --config $MANUALLB/user/user-cluster.yaml --kubeconfig $MANUALLB/admin/kubeconfig
     return 0
   fi
   echo "Only support seesaw and manualLB for now" 1>&2
   return 1
}

function delete-user-cluster {
   if [ -z $1 ]; then
     echo "Please provide either manuallb or seesaw" 1>&2
     return 1
   fi
   if [ $1 == "seesaw" ]; then
     echo "removing user cluster with seesaw"
     gkectl delete cluster --cluster on-prem1 --kubeconfig $SEESAW/admin/kubeconfig
     gcloud container hub memberships delete on-prem1
     gkectl delete loadbalancer --config $KEYS/vsphere.yaml --seesaw-group-file $SEESAW/user/seesaw-for-on-prem1.yaml
     return 0
   fi
   if [ $1 == "manualLB" ]; then
     echo "removing user cluster with manualLB"
     gkectl delete cluster --cluster on-prem1 --kubeconfig ~/.kube/config
     return 0
   fi
   echo "Only support seesaw and manualLB for now" 1>&2
   return 1
   
}
