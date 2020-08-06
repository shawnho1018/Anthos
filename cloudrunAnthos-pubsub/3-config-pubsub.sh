#!/usr/local/bin/bash
source env.sh
echo "replacing helloworld with pubsub service..."
gcloud run services delete --quiet sample
echo "wait until sample service was successfully deleted..."
sleep 15
gcloud run deploy sample --image gcr.io/$PROJECT_ID/pubsub

echo "config pub/sub topic..."
gcloud pubsub topics create sample 

echo "create subscription..."
gcloud pubsub subscriptions create samplesubscription --topic sample \
     --push-endpoint=https://sample.default.shawnk8s.com/

echo 'After this is done, please test using gcloud pubsub topics publish sample --message "Shawnho is the best person in the world!"'
echo "Check gcloud console's cloudrun log which should show the message you tested earlier"
