#!/bin/bash
gcloud compute instance-templates create td-hello-template \
	--machine-type=n1-standard-1 \
	--boot-disk-size=20GB \
	--image-family=debian-10 \
	--image-project=debian-cloud \
	--scopes=https://www.googleapis.com/auth/cloud-platform \
	--tags=td-http-server \
	--metadata=startup-script="#! /bin/bash
sudo apt-get update -y
sudo apt-get install apache2 -y
sudo service apache2 restart
sudo mkdir -p /var/www/html/
echo '<!doctype html><html><body><h1>'\`/bin/hostname\`'</h1></body></html>' | sudo tee /var/www/html/index.html"


gcloud compute instance-templates create td-vm-template \
  --scopes=https://www.googleapis.com/auth/cloud-platform \
  --tags=http-td-tag,http-server,https-server \
  --image-family=debian-9 \
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

