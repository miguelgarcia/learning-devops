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
