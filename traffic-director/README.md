## Traffic Director Talk for Taiwan Recap for Next OnAir for 2020.
### What's Traffic Director? 
Traffic director is the control plane for Service Mesh in GCP. It highly integrated with GCP's component, such as GCLB and Cloudrun. It has 4 advantages over the regular service mesh control plane. 
1. It is a managed service, which implies no self-managed components such as Istio's pilot or Consul connect. 
2. It highly integrated with GCP components. It supports mesh across VM and container. In the recent alpha release, on-prem workloads could also connect to Traffic director to form the mesh. 
3. Instead of Envoy, Traffic Director also supports GRPC's library. It implies no agent is required as the sidecar. 

### How this project is configured? 
This project is used to demonstrate hybrid workloads across multi-regions. 3 different workloads will be deployed across asia-northeast1, asia-east1, and asia-southeast1. Note that a VPC with different subnets are used within this 3 regions. 0-prepare-env.sh is the scrip to lay out the topology.

1-create-apps.sh is to create workloads onto these 3 regions. asia-east1 will have VM deployed and the corresponding template was generated using utilities/prepare-templates.sh. app1 will be deployed as pod in asia-northeast1 while nginx will be deployed as pod in asia-southeast1. Once the deploy is completed, We should be able to see 3 services successfully configured in Traffic Director UI. If not, please run periodic-firewall.sh to open firewalls between health-check and workloads. 

2-config-td.sh is used to configure a basic route to build a connection to workload in asia-east1. After this script is executed, user should be able to execute 3-set-pod-tester.sh to request hello response back. 

3. Try to use 3-export-urlmap.sh to retrieve urlmap setting. Verify the setting with urlmap-2-3ways.yaml to see the difference. If you hope to see 3 way traffic to the 3 multi-regions, run 3-import-urlmap.sh. 

4. 4-create-gclb.sh is used to configure a global load balancer to connect to the earlier service mesh. A middle proxy needs to be deployed to work as bridge between GCLB and mesh network. 4-create-gclb.sh will deploy this middle proxy onto asia-northeast1 region. After the executing 4-create-gclb.sh, go to gclb UI to verify the backend service is in healthy mode. This may take several minutes. Once the service turns into healthy, user could try to connect to GCLB to see the 3-way connections. 

### Reset environment
Run 97-clear-gclb.sh to remove all earlier configurations. Please note that this script won't remove VPC and both kubernetes clusters. You need to remove them manually. 
