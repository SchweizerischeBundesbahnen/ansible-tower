#!/bin/bash -x
allcontainers=`sudo docker ps --all | grep -v "CONTAINER" | cut -d" " -f1`

for container in $allcontainers; do ./remove-jenkins-slave.sh $container; sleep 10; ./create-jenkins-slave.sh; done
