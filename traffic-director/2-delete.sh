gcloud compute forwarding-rules delete --quiet td-vm-forwarding-rule --global
gcloud compute target-http-proxies delete --quiet td-vm-proxy --global 
gcloud compute url-maps remove-host-rule td-vm-urlmap --host hello-world.example.com 
gcloud compute url-maps remove-path-matcher td-vm-urlmap --path-matcher-name td-vm-path-matcher 
gcloud compute url-maps delete --quiet td-vm-urlmap
gcloud compute backend-services delete --quiet td-vm-svc --global 
gcloud compute firewall-rules delete --quiet fw-allow-hc
gcloud compute health-checks delete --quiet td-vm-hc
gcloud compute instance-groups managed delete --quiet backend-$1 --zone asia-east1-a
gcloud compute instance-groups managed delete --quiet client --zone asia-east1-a

