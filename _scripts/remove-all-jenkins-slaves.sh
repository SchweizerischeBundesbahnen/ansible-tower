#!/bin/bash
allcontainers=`sudo docker ps --all | grep "jenkins-slave" | cut -d" " -f1`

for container in $allcontainers; do ./remove-jenkins-slave.sh $container;   done
