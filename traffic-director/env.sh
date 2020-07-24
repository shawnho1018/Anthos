### Google NEXT 2020 Demo
PROJECT_ID="anthos-demo-280104"
gcloud config set project $PROJECT_ID
gcloud config set compute/zone asia-east1-a


echo "Setting up environment variables..."
NETWORK="td"
SUBNET1="subnet-1"
SUBNET2="subnet-2"
SUBNET3="subnet-3"

CLUSTER1="next-cluster1"
CLUSTER2="next-cluster2"
TEMPLATENAME="td-shawn-subnet-2-hello-envoy"

APP1="service-test"
APP1REGION="asia-northeast1"
APP1ZONE="$APP1REGION-a"
APP1BACKEND="$APP1-backend"
APP1HCHECK="$APP1-hcheck"

APP2="next-hello"
APP2REGION="asia-east1"
APP2ZONE="$APP2REGION-a"
APP2BACKEND="$APP2-backend"
APP2HCHECK="$APP2-hcheck"

APP3="nginx-svc"
APP3REGION="asia-southeast1"
APP3ZONE="$APP3REGION-a"
APP3BACKEND="$APP3-backend"
APP3HCHECK="$APP3-hcheck"

NEXTURLMAP="next-urlmap"
NEXTPROXY="next-proxy"
NEXTFRULE="next-frule"
NEXTPATH="next-pathmatcher"


ROUTERNAME="next-gateway"
ROUTERBACKEND="$ROUTERNAME-backend"
ROUTERHCHECK="$ROUTERNAME-hcheck"
ROUTERURLMAP="$ROUTERNAME-urlmap"
ROUTERPROXY="$ROUTERNAME-proxy"
ROUTERFORWARDRULE="$ROUTERNAME-fr"
