#!/bin/bash
#
# takes the registry to bind to as argument
#
if [ $# -eq 0 ]
  then
    echo "Usage: start_registry-web.sh THE_REGISTRY_URL"
  exit -1
fi

REGISTRY=$1

sudo docker run -it -p 8081:8080 --name registry-web \
           -e REGISTRY_TRUST_ANY_SSL=true \
	   -e READONLY=true \
           -e REGISTRY_URL=${REGISTRY} \
           -e REGISTRY_NAME=localhost:5000 \
           hyper/docker-registry-web

