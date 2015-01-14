#!/bin/bash

REGISTRY=registry-t.sbb.ch
IMAGELIST=('base' 'jenkins-slave-base' 'jenkins-master' 'jenkins-slave-base' 'jenkins-slave-js' 'jenkins-slave-mobile-android' 'jenkins-slave-jee' 'jenkins-slave-wmb' 'confluence' 'jira-standalone' 'jrebellicenseserver' 'stash-base' 'stash-internal' 'stash-external')
#IMAGELIST=('base' 'jenkins-master')


error=0

for IMAGE in "${IMAGELIST[@]}"
do
	sudo docker build --rm  -t schweizerischebundesbahnen/${IMAGE} ./${IMAGE}
	if [ $? -ne 0 ]; then
		echo "BUILD failed! Image=$IMAGE"
		error=1
		break;
	fi

	sudo docker tag "schweizerischebundesbahnen/${IMAGE}" "${REGISTRY}/${IMAGE}"
	sudo docker push ${REGISTRY}/${IMAGE}
	sudo docker rmi -f "${REGISTRY}/${IMAGE}"
done

if [ $error -eq 0 ]; then
  for IMAGE in "${IMAGELIST[@]}"
  do
    sudo docker rmi -f "${REGISTRY}/${IMAGE}"
    sudo docker rmi -f "schweizerischebundesbahnen/${IMAGE}"
  done
fi

exit $error
