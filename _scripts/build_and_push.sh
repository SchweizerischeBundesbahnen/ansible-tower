#!/bin/bash


echo "START-PARAMS: $1 - $2"

REGISTRY=$1
TAG=":$2"
#IMAGELIST=('base' 'jenkins-slave-base' 'jenkins-master' 'jenkins-slave-base' 'jenkins-slave-js' 'jenkins-slave-mobile-android' 'jenkins-slave-jee' 'jenkins-slave-wmb' 'confluence' 'jira-standalone' 'jrebellicenseserver' 'stash-base' 'stash-internal' 'stash-external')
IMAGELIST=('base' 'jenkins-master')


error=0

for IMAGE in "${IMAGELIST[@]}"
do
	sudo docker build --rm  -t schweizerischebundesbahnen/${IMAGE}${TAG} ./${IMAGE}
	if [ $? -ne 0 ]; then
		echo "BUILD failed! Image=$IMAGE"
		error=1
		break;
	fi

	sudo docker tag "schweizerischebundesbahnen/${IMAGE}${TAG}" "${REGISTRY}/${IMAGE}${TAG}"
	sudo docker push ${REGISTRY}/${IMAGE}${TAG}
	sudo docker rmi -f "${REGISTRY}/${IMAGE}${TAG}"
done

if [ $error -eq 0 ]; then
  for IMAGE in "${IMAGELIST[@]}"
  do
    sudo docker rmi -f "${REGISTRY}/${IMAGE}${TAG}"
    sudo docker rmi -f "schweizerischebundesbahnen/${IMAGE}${TAG}"
  done
fi

exit $error
