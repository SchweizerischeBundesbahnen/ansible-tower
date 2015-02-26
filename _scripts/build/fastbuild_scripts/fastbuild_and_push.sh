#!/bin/bash
#
# Normally executed from jenkins build job with build_and_push_preproc.sh. But can also be used manually
# in console with two arguments:
# 1. Hostname of registry to push to ( default: registry-t.sbb.ch )
# 2. Tag to use for this build ( default: latest )
#

echo "STATIC BUILD SCRIPT!"
echo "Registry: $1"
echo "Image: $2"
echo "Tag: $3"
echo "Use_tag: $4"

REGISTRY=$1
IMAGE=$2
TAG=":$3"
USE_TAG=$4


WORKDIR=`pwd`
echo "Workdir: ${WORKDIR}"

error=0

#
# rewrite all tags
echo "Rewriting docker from"
FILELIST=`find ${WORKDIR} -name "Dockerfile" | grep -v "/base/"`
for dockerfile in $FILELIST 
do
  search=`grep "FROM schweizerischebundesbahnen" ${dockerfile}`
  echo "Dockerfile: ${dockerfile}"
  echo "Old from: ${search}"
  if [ "$USE_TAG" == "yes" ]; then
    echo "New from: ${search}${TAG}"
    sed -ri "s#${search}#${search}${TAG}#g" ${dockerfile}
    sed -ri "s#schweizerischebundesbahnen#${REGISTRY}#g" ${dockerfile}
  else
    echo "New from: registry.sbb.ch"
    sed -ri "s#schweizerischebundesbahnen#registry.sbb.ch#g" ${dockerfile}
  fi
done

# build and push images
sudo docker build --rm  -t schweizerischebundesbahnen/${IMAGE}${TAG} ./${IMAGE}
if [ $? -ne 0 ]; then
	echo "BUILD failed! Image=$IMAGE"
	exit -1
fi

# if everything is ok till now: push images to internal registry
	
sudo docker tag "schweizerischebundesbahnen/${IMAGE}${TAG}" "${REGISTRY}/${IMAGE}${TAG}"
if [ $? -ne 0 ]; then
	echo "BUILD failed! Tagging image=$IMAGE failed!"
        exit -2
fi

sudo docker push ${REGISTRY}/${IMAGE}${TAG}
if [ $? -ne 0 ]; then
	echo "BUILD failed! Pushing image=$IMAGE failed!"
	exit -3
fi

# delete images from disk
if [ $error -eq 0 ]; then
  sudo docker rmi -f "${REGISTRY}/${IMAGE}${TAG}"
  sudo docker rmi -f "schweizerischebundesbahnen/${IMAGE}${TAG}"
fi

exit $error
