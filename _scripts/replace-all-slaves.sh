#!/bin/bash -x
allcontainers=`sudo docker ps | grep -v "CONTAINER" | grep -v c9c71 | grep -v d989 | grep -v e1f3e | grep -v e5f6b | cut -d" " -f1`

for container in $allcontainers; do ./remove-jenkins-slave.sh $container; ./create-jenkins-slave.sh; done
