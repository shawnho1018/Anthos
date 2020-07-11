## This tutorial is to assist setup traffic director lab
0-prepare.yaml is to enable traffic director api as well as prepare 3 types of VM templates:
* VM with envoy installed: td-envoy-template
* Backend Services (no Envoy): td-hello-template 
* Backend Services (with Envoy installed): td-vm-template

1-deploy.yaml [template-name] is to deploy the following workloads:
* client instance group
* web-server instance group
* health-check
* backend-service 
  * with pathmatcher and host
* proxy
* forwarder

2-delete.yaml [template-name] is to delete the previous installed components
