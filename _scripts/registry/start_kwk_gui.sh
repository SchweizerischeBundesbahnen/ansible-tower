#!/bin/bash
#
# takes the registry to bind to as argument
#
if [ $# -eq 0 ]
  then
    echo "Usage: start_kwk.sh THE_REGISTRY_URL"
  exit -1
fi

REGISTRY=$1

sudo docker run \
  -d \
  -e ENV_DOCKER_REGISTRY_HOST=${REGISTRY} \
  -e ENV_DOCKER_REGISTRY_PORT=5000 \
  -p 8081:80 \
  --name docker-registry-frontend \
  konradkleine/docker-registry-frontend
