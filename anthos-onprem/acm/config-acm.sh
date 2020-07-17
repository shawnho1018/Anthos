#!/bin/bash
export REPO_URL="https://source.developers.google.com/p/${PROJECT_ID}/r/config-repo"

git config credential.helper gcloud.sh
gcloud source repos create config-repo
cd $ACM
gcloud source repos clone config-repo
cd $ACM/config-repo

cp -r $ROOT/bank-of-anthos-scripts/install/acm/config-repo-source/* .

# Set private key to each cluster
kubectx $CLUSTER1
kubectl create secret generic git-creds \
--namespace=config-management-system \
--from-file=ssh=$HOME/.ssh/id_rsa.sme

kubectx $ONPREMCLUSTER
kubectl create secret generic git-creds \
--namespace=config-management-system \
--from-file=ssh=$HOME/.ssh/id_rsa.sme

REPO_URL=ssh://${GCLOUD_ACCOUNT}@source.developers.google.com:2022/p/${PROJECT_ID}/r/config-repo

kubectx $ONPREMCLUSTER
cat $ACM/templates/config_sync.yaml | \
  sed 's|<REPO_URL>|'"$REPO_URL"'|g' | \
  sed 's|<CLUSTER_NAME>|'"$ONPREMCLUSTER"'|g' | \
  sed 's|none|ssh|g' | \
  kubectl apply -f -

kubectx $CLUSTER1
cat $ACM/templates/config_sync.yaml | \
  sed 's|<REPO_URL>|'"$REPO_URL"'|g' | \
  sed 's|<CLUSTER_NAME>|'"$CLUSTER1"'|g' | \
  sed 's|none|ssh|g' | \
  kubectl apply -f -

