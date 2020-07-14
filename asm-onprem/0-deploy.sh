#!/bin/bash
istioctl install --set profile=asm-multicloud
echo "Need to further update istio-ingressgateway's external ip. In seesaw mode, simply add loadBalancerIP: under spec"

