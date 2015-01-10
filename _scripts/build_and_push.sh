#!/bin/bash

#WORKDIR=~/workspace
REGISTRY=registry-t.sbb.ch
#IMAGELIST=('base' 'jenkins-slave-base' 'jenkins-master' 'jenkins-slave-base' 'jenkins-slave-js' 'jenkins-slave-mobile-android' 'jenkins-slave-jee' 'jenkins-slave-wmb')
IMAGELIST=('base' 'jenkins-master')
#GITREPO=https://code.sbb.ch/scm/kd_wzu/wzu-docker.git



error=0

#mkdir $WORKDIR
#cd $WORKDIR
#rm -rf $WORKDIR/*

#git clone ${GITREPO}

#cd wzu-docker

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
