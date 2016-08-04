#!/bin/bash
jenkinsflavour=$1
if [ -z "$jenkinsflavour" ]; then
    echo "A Jenkins flavour must be specified: [jenkins-slave-android,...], see create-jenkins-slave-set.sh"
fi

allcontainers=`sudo docker ps --all | grep "${jenkinsflavour}" | cut -d" " -f1`

for container in $allcontainers; do ./remove-container.sh $container;   done
