#!/bin/bash

echo "**********************************"
echo "* Creating an instance template *"
echo "*********************************"

gcloud compute instance-templates create td-observability-service-vm-template \
  --scopes=https://www.googleapis.com/auth/cloud-platform \
  --tags=http-td-tag,http-server,https-server \
  --image-family=debian-9 \
  --image-project=debian-cloud \
  --metadata=startup-script="#! /bin/bash

sudo apt-get update -y
sudo apt-get install apache2 -y
sudo service apache2 restart
echo '<!doctype html><html><body><h1>'\`/bin/hostname\`'</h1></body></html>' | sudo tee /var/www/html/index.html"

echo "***********************************"
echo "* Starting Managed Instance Group *"
echo "***********************************"
gcloud compute instance-groups managed create td-observability-service-vm-mig \
    --zone us-central1-a --size=1 --template=td-observability-service-vm-template
