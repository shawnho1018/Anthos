#!/bin/bash
create-user-cluster seesaw
create-gke-cluster $CLUSTER1 default

export KUBECONFIG=$HOME/.kube/config:$KEYS/$ONPREMCLUSTER-kubeconfig
kubectl config view --flatten > ~/.kube/config
gcloud container clusters get-credentials $CLUSTER1
export KUBECONFIG=$HOME/.kube/config
kubectl config rename-context "gke_${PROJECT_ID}_${CLUSTER_LOCATION}_${CLUSTER1}" ${CLUSTER1}
kubectl config rename-context cluster ${ONPREMCLUSTER}
gcloud secrets create "$ONPREMCLUSTER-kubeconfig" --replication-policy=automatic --data-file="$KEYS/$ONPREMCLUSTER-kubeconfig"


# add acm operator
kubectx $CLUSTER1;kubectl apply -f $ACM/templates/config-management-operator.yaml 

# register gke cluster
gcloud container hub memberships register $CLUSTER1 \
   --gke-cluster $CLUSTER_LOCATION/$CLUSTER1 --service-account-key-file=" \
   $KEYS/connect-key.json"

# generate login token to console
kubectx $ONPREMCLUSTER 
kubectl create sa gkeadm -n gke-system
kubectl create clusterrolebinding gkeadm-bind --clusterrole cluster-admin --serviceaccount gke-system:gkeadm
secret=$(kubectl describe sa gkeadm -n gke-system | grep Tokens | awk '{print $2}')
token=$(kubectl describe secret $secret -n gke-system | grep token | awk '{print $2}')
echo "Please input the token onto gcp console to login cluster"
echo "$token"
echo ''
