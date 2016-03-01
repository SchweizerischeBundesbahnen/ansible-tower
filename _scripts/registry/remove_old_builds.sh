#!/bin/bash

BRANCH=$1
dryrun=$2

# max build to keep
MAX_BUILDS=5

# usage
if [ ! "$#" -gt 0 ]
then
  echo "Usage: $0 dev --dry-run"
  exit 1
fi

export REGISTRY_DATA_DIR=/var/data/registry/docker/registry/v2/

list=`curl --silent -X GET https://registry.sbb.ch/v2/_catalog?n=1000 | jq '.repositories[]' | grep kd_wzu`

for image in ${list}; do
	if [ "${1}" = "master" ]; then
		tagcount=`curl --silent -X GET https://registry.sbb.ch/v2/${image:1: -1}/tags/list | jq '.tags[]' | grep -v "dev" | grep -v "latest" |  wc -l`
	else
		tagcount=`curl --silent -X GET https://registry.sbb.ch/v2/${image:1: -1}/tags/list | jq '.tags[]' | grep ${BRANCH} | grep -v "latest" |  wc -l`
	fi
	echo "${image} has ${tagcount} builds"
	
	if [ ${tagcount} -gt ${MAX_BUILDS} ]; then
		echo "Too many builds, delete oldest"
		if [ "${1}" = "master" ]; then
			tags=`curl --silent -X GET https://registry.sbb.ch/v2/${image:1: -1}/tags/list | jq '.tags[]' | grep -v "dev" | grep -v "latest"`
			# problem: was machen mit feature Branches?
		else
			tags=`curl --silent -X GET https://registry.sbb.ch/v2/${image:1: -1}/tags/list | jq '.tags[]' | grep ${BRANCH} | grep -v "latest"`
		fi
		for tag in ${tags}; do
		      #if [ "${tag:1: -1}" = "${TAG_TO_DELETE}" ]; then
		      echo "processing ${image:1: -1}:${tag:1: -1}"
		      #./delete_docker_registry_image --image ${image:1: -1}:${tag:1: -1} $dryrun
		      #fi
	        done
	fi
done
