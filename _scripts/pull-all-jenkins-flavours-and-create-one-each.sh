#!/bin/bash

# takes three arguments:
# registry: repository to pull the images from (registry-t.sbb.ch)
# tag: git branch (used as tag) to deploy (feature/WZU-2994)
# ci to use (http://ci-t.sbb.ch)

echo "Start: $1 - $2 - $3"

# get repository from argument. Defaults to schweizerischebundesbahnen (external registry) if not set.
repository=$1
if [[ -z "$repository" ]]; then
    repository="schweizerischebundesbahnen"
fi

# get image tag to deploy, since we give the full git branch, we have to remove the feature first
tag=`basename $2`

# get the master ci
ci=$3

error=0
tasklist=('jenkins-slave-js' 'jenkins-slave-mobile-android' 'jenkins-slave-jee' 'jenkins-slave-wmb')

for task in "${tasklist[@]}"
do
  echo "$task"
  sudo docker pull "${repository}/${task}:${tag}"
  if [ $? -ne 0 ]; then
    echo "PULL failed! Image=${repository}/${task}:${tag}"
    error=1
    break;
  fi
done


# FIXME: start containers with new images



exit $error
