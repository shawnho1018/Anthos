gcloud compute instance-templates create td-demo-hello-world-template \
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

gcloud compute instance-groups managed create td-demo-hello-world-mig \
  --zone asia-east1-a \
  --size=2 \
  --template=td-demo-hello-world-template
