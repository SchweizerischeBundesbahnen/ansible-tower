#!/bin/bash
#
# Normally executed from jenkins build job with build_and_push_preproc.sh. But can also be used manually
# in console with two arguments:
# 1. Hostname of registry to push to ( default: registry-t.sbb.ch )
# 2. Tag to use for this build ( default: latest )
#

echo "Registry: $1"
echo "Tag: $2"

REGISTRY=$1
TAG=":$2"

# imagelist: Take care of order!
IMAGELIST=('base' 'jenkins-slave-base' 'jenkins-master' 'jenkins-slave-js' 'jenkins-slave-mobile-android' 'jenkins-slave-jee' 'jenkins-slave-jee-release' 'jenkins-slave-wmb' 'jenkins-slave-iib9' 'jira-standalone' 'jrebellicenseserver' 'confluence' 'stash-base' 'stash-internal' 'gitrpm')
#IMAGELIST=('base' 'jenkins-master')

WORKDIR=`pwd`
echo "Workdir: ${WORKDIR}"

error=0

# rewrite all tags
echo "Rewriting docker from"
FILELIST=`find ${WORKDIR} -name "Dockerfile" | grep -v "/base/"`
for dockerfile in $FILELIST 
do
  search=`grep "FROM schweizerischebundesbahnen" ${dockerfile}`
  echo "Dockerfile: ${dockerfile}"
  echo "Old from: ${search}"
  echo "New from: ${search}${TAG}"
  sed -ri "s#${search}#${search}${TAG}#g" ${dockerfile}
done

# build and push images
for IMAGE in "${IMAGELIST[@]}"
do
	sudo docker build --rm  -t schweizerischebundesbahnen/${IMAGE}${TAG} ./${IMAGE}
	if [ $? -ne 0 ]; then
		echo "BUILD failed! Image=$IMAGE"
		exit -1
	fi
done

# if everything is ok till now: push images to internal registry
for IMAGE in "${IMAGELIST[@]}"
do
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
done

# delete images from disk
if [ $error -eq 0 ]; then
  for IMAGE in "${IMAGELIST[@]}"
  do
    sudo docker rmi -f "${REGISTRY}/${IMAGE}${TAG}"
    sudo docker rmi -f "schweizerischebundesbahnen/${IMAGE}${TAG}"
  done
fi

exit $error
