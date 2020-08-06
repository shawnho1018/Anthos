#!/usr/local/bin/bash
gcloud pubsub subscriptions delete --quiet samplesubscription
gcloud pubsub topics delete --quiet sample
gcloud run services delete --quiet sample
