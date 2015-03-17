#!/bin/bash
#
# This scripts removes a tag from all libraries in given registry. Can be used together with 
# remove_orphan_images.sh
#
#
if [ ! $# -eq 2 ]; then
  echo "Usage: remove_tag.sh TAG REGISTRY"
  echo "Sample: remove_tag.sh WZU-3110 registry-t.sbb.ch"
  exit -1
fi

TAG=$1
REGISTRY=$2

LIBRARIES=`curl -s -X GET https://${REGISTRY}/v1/search | jq '.results[].name'`

for LIBRARY in $LIBRARIES; do

  echo "delete ${TAG} in ${LIBRARY:1:-1}"
  curl -X DELETE https://${REGISTRY}/v1/repositories/${LIBRARY:1:-1}/tags/${TAG}
  echo " "
done
