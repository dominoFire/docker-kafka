#! /bin/bash

. vars.sh

set -o xtrace

echo "Corriendo imagen Docker $IMAGE_NAME"
docker run \
 -p 9092:9092 \
 -t $IMAGE_NAME
