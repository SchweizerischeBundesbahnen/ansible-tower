#!/bin/bash

TAG_TO_DELETE=$1

#dryrun=--dry-run
dryrun=$2


if [ ! "$#" -gt 0 ]
then
  echo "Usage: $0 230-dev --dry-run"
  exit 1
fi

export REGISTRY_DATA_DIR=/var/data/registry/docker/registry/v2/


list=`curl --silent -X GET https://registry.sbb.ch/v2/_catalog?n=1000 | jq '.repositories[]' | grep kd_wzu`
# | egrep "androidsdk|backupsshserver|base|base7|base8|confluence|jira|jrebellicenseserver|sonar|sshvm|stash|was85|wzuscheduler"  | grep -v cloud | grep -v wzuself | grep -v plattform | grep -v ngin`

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
