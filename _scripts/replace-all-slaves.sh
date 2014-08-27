#!/bin/bash -x
allcontainers=`sudo docker ps | grep -v "CONTAINER" | cut -d" " -f1`

for container in $allcontainers; do ./remove-jenkins-slave.sh $container; ./create-jenkins-slave.sh; done
