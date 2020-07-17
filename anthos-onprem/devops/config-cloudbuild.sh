#!/bin/bash
gcloud source repos create ${REPO_NAME}
gcloud source repos clone ${REPO_NAME}
mkdir -p "${REPO_NAME}/$ONPREMCLUSTER"
mkdir -p "${REPO_NAME}/$CLUSTER1"
gcloud beta builds triggers create cloud-source-repositories \
--repo=${REPO_NAME} \
--branch-pattern="master" \
--build-config="cloudbuild.yaml"

# add privilege to cloudbuild service account. This service account needs to be viewed from UI
export CBSA="1039418189055@cloudbuild.gserviceaccount.com"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
--member "serviceAccount:$CBSA" \
--role roles/gkehub.gatewayAdmin

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
--member "serviceAccount:$CBSA" \
--role roles/gkehub.viewer
# refer to this alpha doc https://docs.google.com/document/d/1JNazhLOZn-La96isNOUpwKaLD6KD5trAfz2OKpqkboQ/edit#
sed "s/{USER_ACCOUNT}/${CBSA}/g" cluster-impersonate.yaml | kubectl apply -f -
