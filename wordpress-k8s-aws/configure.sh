#!/bin/sh

set -e

./scripts/install-deps.sh
./scripts/create-secrets.sh
./scripts/create-storage-class.sh

echo Warning: volumes are going to be created right now

./scripts/create-volumes.sh
./scripts/create-wordpress.sh

echo "Configuration ready, use ./deploy.sh to deploy to cluster"