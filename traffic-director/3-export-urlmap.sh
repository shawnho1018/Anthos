#!/bin/bash
echo "export urlmap config"
echo "gcloud compute url-maps export next-urlmap --destination ./urlmap-2-vm.yaml"
gcloud compute url-maps export next-urlmap --destination ./urlmap-2-vm.yaml
