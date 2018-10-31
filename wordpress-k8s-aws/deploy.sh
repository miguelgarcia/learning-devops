#!/bin/bash

if [ ! -f .wordpress_uploads_fs ]; then
    echo "Error: run ./configure.sh before deploying"
    exit 1
fi

kubectl apply -f config

echo ""
echo "Done, use kubectl get service to lookup the URL of the load balancer"
echo "Optionally use route53 to create an alias for the load balancer"
echo ""
echo "Use ./delete.sh to remove all the resources from the cluster and AWS"