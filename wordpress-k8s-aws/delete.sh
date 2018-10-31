#!/bin/bash

set -e 

source .wordpress_uploads_fs

kubectl delete -f config
aws efs delete-mount-target --mount-target-id ${UPLOADS_MOUNT_TARGET_ID}

# Wait mount target deletion
MOUNT_TARGETS=""
until [ "${MOUNT_TARGETS}" == "[]" ]; do
    echo "Waiting for mount target to be deleted"
    MOUNT_TARGETS=`aws efs describe-mount-targets --file-system-id=${UPLOADS_FILE_SYSTEM_ID} | ./deps/jq -r .MountTargets`
    sleep 5
done

aws efs delete-file-system --file-system-id ${UPLOADS_FILE_SYSTEM_ID}
rm .wordpress_uploads_fs