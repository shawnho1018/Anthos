#GCP
PROJECT_ID="anthos-demo-280104"
ROUTERNAME="td-gateway"
ROUTERBACKEND="$ROUTERNAME-backend"
ROUTERHCHECK="$ROUTERNAME-hcheck"
ROUTERURLMAP="$ROUTERNAME-urlmap"
ROUTERPROXY="$ROUTERNAME-proxy"
ROUTERFORWARDRULE="$ROUTERNAME-fr"

gcloud config set project $PROJECT_ID
gcloud config set compute/zone asia-east1-a

#File architecture
