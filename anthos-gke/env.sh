#!/use/local/bin/bash
PROJECT_ID="anthos-demo-280104"
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")
MESH_ID="proj-${PROJECT_NUMBER}"
GCLOUD_ACCOUNT=$(gcloud config get-value account)
gcloud config set project $PROJECT_ID
gcloud config set compute/zone asia-east1-a
ROOT="/Users/shawnho/workspace/Anthos/asm-lab/swagger-workshop"

#VPC="swagger"
KEYS="/Users/shawnho/workspace/gcp-keys"
#SUBNET1="$VPC-subnet1"
#SUBNET2="$VPC-subnet2"
VPC="default"
SUBNET1="default"
SUBNET2="default"

CLUSTER1="taiwan-1"
CLUSTER1ZONE="asia-east1-a"
CLUSTER1REGION="asia-east1"
CLUSTER2="singapore"
CLUSTER2ZONE="asia-southeast1-a"
CLUSTER2REGION="asia-southeast1"
CLUSTER1CIDRNAME="$CLUSTER1-pods"
CLUSTER2CIDRNAME="$CLUSTER2-pods"

# ACM ENV
ACM="$ROOT/acm"
ACMREPO="ssh://${GCLOUD_ACCOUNT}@source.developers.google.com:2022/p/${PROJECT_ID}/r/config-repo"
SOURCEREPO="ssh://${GCLOUD_ACCOUNT}@source.developers.google.com:2022/p/${PROJECT_ID}/r/app-config-repo"
GITUSER="shawnho"
SOURCEPATH="$ROOT/app-config-repo"
ACMPATH="$ROOT/config-repo"
