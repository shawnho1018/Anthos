## This is a hybrid LAB setup for Anthos-hybrid

### Preparation
1. Place 2 keys in keys folder
* Whitelisted-key.json: needs to bind project owner role as well as being whitelisted to download anthos on-prem
* connect-key.json: needs to bind the following roles for anthos hub registration
  	*  roles/gkehub.admin 
	*  roles/iam.serviceAccountAdmin
	*  roles/iam.serviceAccountKeyAdmin
	*  roles/resourcemanager.projectIamAdmin

2. Update the necessary environmental variables: your project_id, clusterlocation.
3. Update vsphere.yaml in keys/
4. Install kubectl, kubectx, nomos in your linux client

### Execution
The execution sequence is:
#### Spin up clusters
1. source env.sh to get necessary environment variables and functions
2. execute acm/bootstrap.sh to spin up two clusters (one is on-premise; the other is on GKE)
#### Setup ACM
3. use get-key.sh to produce a key pair for ACM. Please note this key must match the user who is authorized to login to GCS. 
4. Register your public key to allow cluster to access GCS. 
5. use the following commands to check the status.  
```
nomos status
```
6. Add your configuration settings onto config-repo and commit those to GCS. 
#### Setup DevOps
7. The current pipeline utilize connect-gateway to do a cross-cluster cloud build pipeline. Any code change in app-repo-config could directly trigger build.

