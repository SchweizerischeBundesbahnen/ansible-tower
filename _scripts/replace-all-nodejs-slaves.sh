#!/bin/bash -x
allcontainers=`sudo docker ps --all | grep -v "CONTAINER" | grep jenkins-slave-js | cut -d" " -f1`

for container in $allcontainers; do ./remove-jenkins-slave.sh $container; sleep 10; ./create-jenkins-slave.sh jenkins-slave-js; done
