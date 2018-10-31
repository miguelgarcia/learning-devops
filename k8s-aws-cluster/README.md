# Tools to create and delete a k8s cluster on AWS

## Dependencies

First install and configure:
 - kops
 - aws cli

 The configured aws user must have the following permissions:

- AmazonEC2FullAccess
- IAMFullAccess
- AmazonS3FullAccess
- AmazonVPCFullAccess
- AmazonElasticFileSystemFullAccess
- AmazonRoute53FullAccess

## Configure Cluster:
Configure the cluster modifying `config.sh`.

    # AWS region and zones config
    AWS_REGION=us-west-1
    AWS_ZONES=us-west-1a

    # S3 bucket for cluster config resources
    S3_BUCKET_NAME=zzmike-kops-course
    export KOPS_STATE_STORE=s3://${S3_BUCKET_NAME}

    # DNS config, the hosted zone DNS_ZONE must already exist in Route53
    DNS_ZONE=miguel.ga
    export KOPS_CLUSTER_NAME=k8s.miguel.ga

    # Cluster size config
    CLUSTER_NODE_COUNT=2
    CLUSTER_NODE_SIZE=t2.micro
    CLUSTER_MASTER_SIZE=t2.micro

`S3_BUCKET_NAME` is the bucket where clusters configuration will be stored.

`DNS_ZONE` is the name of one of your **already** existing Hosted Zones.

## Create Cluster

Run `create-cluster.sh` to create the cluster. After this `kubectl` will be configured to use the new cluster.

## Delete Cluster

Run `delete-cluster.sh` to delete the cluster.
