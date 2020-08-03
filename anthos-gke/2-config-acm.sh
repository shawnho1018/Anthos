#!/bin/bash
source env.sh
gcloud services enable anthos.googleapis.com
gcloud alpha container hub config-management enable
echo "Clone acm project..."
gcloud source repos clone $ACMREPO
git config --global user.email ${GITUSER}@google.com   
git config --global user.name ${GITUSER} 

for c in c1 c2; do
  kubectx $c
  kubectl apply -f "$ACM/config-management-operator.yaml"
  kubectl create secret generic git-creds \
    --namespace=config-management-system \
    --from-file=ssh=$KEYS/id-rsa.sme
done

kubectx c1
cat $ACM/config_sync.yaml | sed -e 's|<REPO_URL>|'"$ACMREPO"'|g' | sed -e 's|<CLUSTER_NAME>|'"$CLUSTER1"'|g' | sed -e 's|none|ssh|g' > "$ACM/$CLUSTER1.yaml"
kubectl apply -f "$ACM/$CLUSTER1.yaml"

kubectx c2
cat $ACM/config_sync.yaml | sed -e 's|<REPO_URL>|'"$ACMREPO"'|g' | sed -e 's|<CLUSTER_NAME>|'"$CLUSTER2"'|g' | sed -e 's|none|ssh|g' > "$ACM/$CLUSTER2.yaml"
kubectl apply -f "$ACM/$CLUSTER2.yaml"
