#!/bin/bash
gkectl delete loadbalancer --config ./vsphere.yaml --seesaw-group-file ./seesaw-for-on-prem1.yaml
gkectl delete cluster --cluster on-prem1 --kubeconfig ../admin/kubeconfig
