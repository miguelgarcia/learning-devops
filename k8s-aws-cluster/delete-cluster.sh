#!/bin/bash

set -e

echo "Type \"kill cluster\" to proceed"
read
if [ "${REPLY}" != "kill cluster" ]; then
  echo bye
  exit 1
fi

source config.sh

kops delete cluster ${NAME} --yes
aws s3 rb --force ${KOPS_STATE_STORE}