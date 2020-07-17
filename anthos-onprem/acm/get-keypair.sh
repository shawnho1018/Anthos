#!/bin/bash
ssh-keygen -t rsa -b 4096 \
-C "$GCLOUD_ACCOUNT" \
-N '' \
-f $HOME/.ssh/id_rsa.sme

