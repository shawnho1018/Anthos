# This function is to define environment variables
#!/bin/bash

#GCP
gcloud config set project "anthos-demo-280104"

#File architecture
export ROOT=$(pwd) 
export SEESAW=$ROOT/seesaw
export MANUALLB=$ROOT/manualLB
export KEY=$ROOT/key
