#!/bin/bash
openssl \
req  \
-nodes -new -x509 \
-keyout ./ingress-wildcard.key \
-out ./ingress-wildcard.crt \
-subj "/C=TW/ST=TPE/L=TPE101/O=GCPTW\
/OU=GKE/CN=nginx.shawn.lab/emailAddress=dev@shawn.lab"

kubectl create secret tls --namespace gke-system ingressgateway-wildcard-cacerts --cert ./ingress-wildcard.crt --key ./ingress-wildcard.key
