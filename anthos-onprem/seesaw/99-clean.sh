#!/bin/bash
gkectl delete cluster --cluster on-prem1 --kubeconfig ../admin/kubeconfig
gkectl delete loadbalancer --config ./vsphere.yaml --seesaw-group-file ./seesaw-for-on-prem1.yaml
