#!/bin/bash -x
allcontainers=`sudo docker ps | grep -v "CONTAINER" | grep jenkins-slave-android | cut -d" " -f1`

for container in $allcontainers; do ./remove-jenkins-slave.sh $container; ./create-jenkins-android-slave.sh; done
