#!/bin/bash -x
allcontainers=`sudo docker ps --all | grep -v "CONTAINER" | cut -d" " -f1`

for container in $allcontainers; do ./remove-container.sh $container;   done
