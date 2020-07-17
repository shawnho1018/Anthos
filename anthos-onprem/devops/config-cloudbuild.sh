#!/bin/bash
gcloud source repos create ${REPO_NAME}
gcloud source repos clone ${REPO_NAME}
mkdir -p "${REPO_NAME}/$ONPREMCLUSTER"
mkdir -p "${REPO_NAME}/$CLUSTER1"
gcloud beta builds triggers create cloud-source-repositories \
--repo=${REPO_NAME} \
--branch-pattern="master" \
--build-config="cloudbuild.yaml"

