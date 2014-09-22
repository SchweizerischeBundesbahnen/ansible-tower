#!/bin/bash -x
allcontainers=`sudo docker ps | grep -v "CONTAINER" | grep jenkins-slave-js | cut -d" " -f1`

for container in $allcontainers; do ./remove-jenkins-slave.sh $container; ./create-jenkins-nodejs-slave.sh; done
