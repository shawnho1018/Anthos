## Deploy Kubeflow on GKE
This deployment follows the guide: [Deploy Using CLI](https://www.kubeflow.org/docs/gke/deploy/deploy-cli/)
The only difficulty is to configure the OAUTH in GCP to make it work. The deployment only takes 2 step: 
* Config environment variables
* kfctl deploy -V -f $CONFIG_URI

After it is deployed, remember it took around 10~20 minutes to have the kubeflow ready. The link can be accessed from
https://[kubeflow-name].endpoints.[project-id].goog
