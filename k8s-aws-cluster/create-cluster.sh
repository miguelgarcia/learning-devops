#!/bin/bash

set -e 

source config.sh

# Create S3 storage for cluster config
aws s3api create-bucket \
    --bucket ${S3_BUCKET_NAME} \
    --region ${AWS_REGION} \
    --create-bucket-configuration LocationConstraint=${AWS_REGION}

aws s3api put-bucket-encryption \
    --bucket ${S3_BUCKET_NAME} \
    --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

# Configure cluster
kops create cluster \
    --zones ${AWS_ZONES} \
    --name=${KOPS_CLUSTER_NAME} \
    --state=${KOPS_STATE_STORE} \
    --node-count=${CLUSTER_NODE_COUNT} \
    --node-size=${CLUSTER_NODE_SIZE} \
    --master-size=${CLUSTER_MASTER_SIZE} \
    --dns-zone=${DNS_ZONE}

# Create cluster
kops update cluster --name ${KOPS_CLUSTER_NAME} --yes