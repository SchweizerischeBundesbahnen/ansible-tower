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
declare -A imagelist
imagelist['jenkins-slave-js']="nodejs"
imagelist['jenkins-slave-mobile-android']="android"
imagelist['jenkins-slave-jee']="yves"
imagelist['jenkins-slave-wmb']="wmb"

for image in "${!imagelist[@]}"
do
  echo "$image"
  sudo docker pull "${repository}/${image}:${tag}"
  sudo docker tag  "${repository}/${image}:${tag}" "schweizerischebundesbahnen/${image}:${tag}"
  ./create-jenkins-slave.sh ${image} ${ci} ${imagelist[$image]}
  if [ $? -ne 0 ]; then
    echo "PULL failed! Image=${repository}/${task}:${tag}"
    error=1
    break;
  fi
done


exit $error
