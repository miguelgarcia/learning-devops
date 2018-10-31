#!/bin/bash

set -e

echo "Installing dependencies"

mkdir -p deps

if [ ! -f deps/jq ]; then
    wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O deps/jq
    chmod +x deps/jq
fi

echo "Dependencies installed"