#!/bin/bash
echo "export urlmap config"
echo "gcloud compute url-maps export next-urlmap --destination ./urlmap-2-3ways.yaml"
gcloud compute url-maps import next-urlmap --source ./urlmap-2-3ways.yaml
