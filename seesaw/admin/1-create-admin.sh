#!/bin/bash
gkectl check-config admin --config admin-cluster.yaml
gkectl create admin --config admin-cluster.yaml
