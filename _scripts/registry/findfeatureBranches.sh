#!/bin/bash

# if this script is started with an argument, the tags will be deleted!
DELETE=$1

# get all wzu repositories
list=`curl --silent -X GET https://registry.sbb.ch/v2/_catalog?n=1000 | jq '.repositories[]' | grep kd_wzu`
all_tags=()

function deleteTags() {
	for tag in ${1}; do
                echo "deleting tag ${tag:1: -1}"
                ./cleanup.sh ${tag:1: -1}
        done
}

# collect all tags of all images
for image in ${list}; do
	echo "Getting tags for ${image}\n"

	tags=`curl --silent -X GET https://registry.sbb.ch/v2/${image:1: -1}/tags/list | jq '.tags[]' | grep -v -E 'latest|.*-dev|^\"[0-9]{3}|[0-9]{1}\.[0-9]{1}' | sort | uniq`

	echo -en "${tags}\n"

        if [ ! -z ${DELETE}  ]; then
		deleteTags ${tags}
	fi
        
done


