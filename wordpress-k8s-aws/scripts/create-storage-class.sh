#!/bin/bash

set -e 

echo "Configuring Storage classes"

source ../k8s-aws-cluster/config.sh

cat <<EOF > config/storage.yml
kind: StorageClass
apiVersion: storage.k8s.io/v1beta1
metadata:
  name: standard
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
  zone: ${AWS_ZONES}

EOF

echo "Storage classes configured"