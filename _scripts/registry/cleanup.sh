#!/bin/bash

TAG_TO_DELETE=231-dev

#dryrun=--dry-run
dryrun=

list=`curl --silent -X GET https://registry.sbb.ch/v2/_catalog?n=1000 | jq '.repositories[]' `

for image in ${list}; do

#	echo ${image:1: -1}
	tags=`curl --silent -X GET https://registry.sbb.ch/v2/${image:1: -1}/tags/list | jq '.tags[]'`
	for tag in ${tags}; do
		if [ "${tag:1: -1}" = "${TAG_TO_DELETE}" ]; then
			echo "delete ${image:1: -1}:${tag:1: -1}"
			./delete_docker_registry_image --image ${image:1: -1}:${tag:1: -1} $dryrun
		fi
	done
done
