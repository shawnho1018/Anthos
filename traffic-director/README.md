## This tutorial is to assist setup traffic director lab
### Preparation
* source env.sh to apply environment variables.
* add alias-ip to your GKE
* add roles/compute.networkViewer to your service-account or enable workload identity

#### Step 1
0-prepare.yaml is to enable traffic director api as well as prepare 3 types of VM templates:
* VM with envoy installed: td-envoy-template
* Backend Services (no Envoy): td-shawn-subnet-2-hello
* Backend Services (with Envoy installed): td-shawn-subnet-2-hello-envoy
* Backend Services (with Envoy only - works as VM): td-shawn-subnet-2-envoy
#### Step 2
1-create-vpc.yaml is used to create VPC
#### Step 3
2 has 3 branches:
* 2-create-gke-service.sh: create stand-alone GKE app1 service binding to traffic director
* 2-create-service.sh: create stand-alone Hello VM service binding to traffic director
* 2-create-hybrid.sh: create workloads which sends traffic to standalone app1 and Hello VM at a weight of 50/50. 
#### Step 4
3 has 2 branches:
* 3-set-tester.yaml: create an envoy-enabled VM to connect into mesh. This VM could connect to any of the services on traffic director
* 3-set-pod-tester.yaml: create a busybox pod and connect to the corresponding service. 

#### GCLB configuration [Todo]
* This configuration is still configured by UI. The key is to apply both gateway-proxy-svc.yaml and gateway-proxy.yaml to create an NEG. 
* Configure GCLB to connect to the backend service which consists of this NEG.
* Only 1 default urlmap needs to apply. 

#### Last Step 
99-clear.sh:
* Delete all services including VM and containers. 

### Worth to mention:
If your environment is under google.com, there is an policy enforcer, which will block the health monitoring between GCLB to the backend. To resolve this issue, during the lab execution, please open a thread to run periodic-firewall.sh. 
