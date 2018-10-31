#!/bin/bash

set -e 

echo "Creating volumes"

source ../k8s-aws-cluster/config.sh

SUBNET_ID=`aws ec2 describe-subnets | ./deps/jq -r ".Subnets[] | select(.Tags[] | .Value==\"${KOPS_CLUSTER_NAME}\") | .SubnetId"`
if [ "${SUBNET_ID}" == "" ]; then
    echo Could not retrieve cluster subnet id >&2
    exit 1
fi

SECURITY_GROUP_ID=`aws ec2 describe-security-groups | ./deps/jq -r '.SecurityGroups[] | select(.Description=="Security group for nodes") | .GroupId'`
if [ "${SECURITY_GROUP_ID}" == "" ]; then
    echo Could not retrieve nodes security group >&2
    exit 2
fi

# Create Wordpress uploads efs
UUID=`uuidgen`
FILE_SYSTEM_ID=`aws efs create-file-system --creation-token ${UUID} | ./deps/jq -r '.FileSystemId'`
echo FS ${FILE_SYSTEM_ID} created

echo "UPLOADS_FILE_SYSTEM_ID=${FILE_SYSTEM_ID}" > .wordpress_uploads_fs

# Wait for file system to be available
FS_STATUS=""
until [ "${FS_STATUS}" == "available" ]; do
    echo "Waiting for file system to be available"
    FS_STATUS=`aws efs describe-file-systems --file-system-id ${FILE_SYSTEM_ID} | ./deps/jq -r ".FileSystems[0].LifeCycleState"`
    sleep 5
done

MOUNT_TARGET_ID=`aws efs create-mount-target --file-system-id ${FILE_SYSTEM_ID} --subnet-id ${SUBNET_ID} --security-groups ${SECURITY_GROUP_ID} | ./deps/jq -r '.MountTargetId'`
echo UPLOADS_MOUNT_TARGET_ID=${MOUNT_TARGET_ID} >> .wordpress_uploads_fs
echo Mount target ${MOUNT_TARGET_ID} created

# Wait for mount target to be available
MOUNT_TARGET_STATUS=""
until [ "${MOUNT_TARGET_STATUS}" == "available" ]; do
    echo "Waiting for mount target to be available"
    MOUNT_TARGET_STATUS=`aws efs describe-mount-targets --mount-target-id ${MOUNT_TARGET_ID} | ./deps/jq -r ".MountTargets[0].LifeCycleState"`
    sleep 5
done

echo "Volumes created"