#!/bin/bash

#開啟OS config API
gcloud services enable osconfig.googleapis.com
gcloud services enable trafficdirector.googleapis.com


function add-to-td {
	if [ -z $1 ]; then
		echo "Please provide background-service name"
		return 1
	fi
	if [ -z $2 ]; then
		echo "Please provide compute instance name"
		return 1
	fi 
	BSNAME=$1
	INSTANCENAME=$2
	echo "backend service name: $BSNAME"
	gcloud compute health-checks create http "${BSNAME}-check"
	gcloud compute backend-services create $BSNAME --global \
		--load-balancing-scheme=INTERNAL_SELF_MANAGED \
		--health-checks "$BSNAME-check"
    gcloud compute backend-services add-backend $BSNAME --instance-group $INSTANCENAME \
	--instance-group-zone asia-east1-a --global

}
function createForwarding {
	if [ -z $1 ]; then
		echo "Please provide forwarding rule name"
		return 1
	fi
	if [ -z $2 ]; then
		echo "Please provide network name"
		return 1
	fi 	
	if [ -z $3 ]; then
		echo "Please provide proxy name"
		return 1
	fi
	FORWARDINGRULE=$1
	NETWORK=$2
	PROXYNAME=$3
	gcloud compute forwarding-rules create $FORWARDINGRULE \
		--global \
		--load-balancing-scheme=INTERNAL_SELF_MANAGED \
		--address=10.0.0.1 \
		--target-http-proxy=$PROXYNAME \
		--ports 80 \
		--network $NETWORK
}
function setProxy {
	if [ -z $1 ]; then
		echo "please provide backend service"
		return 1
	fi 
    # set urlmap
	echo '---Add routing rules'
	gcloud compute url-maps create $BSNAME-urlmap --default-service $BSNAME
	echo '---Add proxies'
	gcloud compute target-http-proxies create $BSNAME-proxy --url-map $BSNAME-urlmap
}

function deploy-vm {
	if [ -z $1 ]; then
		echo "Please provide template name"
		return 1
	fi
	if [ -z $2 ]; then
		echo "Please provide compute instance name"
		return 1
	fi 
	TEMPLATENAME=$1
	IGNAME=$2
	gcloud compute instance-groups managed create $IGNAME \
  		--zone asia-east1-a \
  		--size=2 \
  		--template=$TEMPLATENAME			
}

function prepare-template {
	if [ -z $1 ]; then
		echo "Please provide template name"
		return 1
	fi
	if [ -z $2 ]; then
		echo "Please provide subnet name"
		return 1
	fi 
	TEMPLATENAME=$1
	SUBNET=$2
gcloud beta compute instance-templates create td-$TEMPLATENAME-$SUBNET-envoy \
	--service-proxy=enabled \
	--network-interface=subnet=$SUBNET

gcloud compute instance-templates create td-$TEMPLATENAME-$SUBNET-hello \
	--machine-type=n1-standard-1 \
	--boot-disk-size=20GB \
	--image-family=debian-10 \
	--image-project=debian-cloud \
	--scopes=https://www.googleapis.com/auth/cloud-platform \
	--tags=td-http-server \
	--network-interface=subnet=$SUBNET\
	--metadata=startup-script="#! /bin/bash
	sudo apt-get update -y
	sudo apt-get install apache2 -y
	sudo service apache2 restart
	sudo mkdir -p /var/www/html/
	echo '<!doctype html><html><body><h1>'\`/bin/hostname\`'</h1></body></html>' | sudo tee /var/www/html/index.html"

gcloud compute instance-templates create td-$TEMPLATENAME-$SUBNET-hello-envoy\
  --scopes=https://www.googleapis.com/auth/cloud-platform \
  --tags=http-td-tag,http-server,https-server \
  --network-interface=subnet=subnet-2 --image-family=debian-9 \
  --image-project=debian-cloud \
  --metadata=startup-script="#! /bin/bash

# Add a system user to run Envoy binaries. Login is disabled for this user
sudo adduser --system --disabled-login envoy
# Download and extract the Traffic Director tar.gz file
sudo wget -P /home/envoy https://storage.googleapis.com/traffic-director/traffic-director.tar.gz
sudo tar -xzf /home/envoy/traffic-director.tar.gz -C /home/envoy
sudo cat << END > /home/envoy/traffic-director/sidecar.env
ENVOY_USER=envoy
# Exclude the proxy user from redirection so that traffic doesn't loop back
# to the proxy
EXCLUDE_ENVOY_USER_FROM_INTERCEPT='true'
# Intercept all traffic by default
SERVICE_CIDR='*'
GCP_PROJECT_NUMBER=''
VPC_NETWORK_NAME=''
ENVOY_PORT='15001'
ENVOY_ADMIN_PORT='15000'
LOG_DIR='/var/log/envoy/'
LOG_LEVEL='info'
XDS_SERVER_CERT='/etc/ssl/certs/ca-certificates.crt'
END
sudo apt-get update -y
sudo apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/debian stretch stable' -y
sudo apt-get update -y
sudo apt-get install docker-ce apache2 -y
sudo service apache2 restart
echo '<!doctype html><html><body><h1>'\`/bin/hostname\`'</h1></body></html>' | sudo tee /var/www/html/index.html
sudo /home/envoy/traffic-director/pull_envoy.sh
sudo /home/envoy/traffic-director/run.sh start"
}