#!/bin/bash
#
# Removes old and idle slaves from slave host. Takes at least one argument: the ci master url
# The second optional argument is for the automatic rollover and is just a definition of "old"
#


# which master to use
master=$1

# default definition of old
timethreshold=$2


function usage() {
        echo "You need to provide the following parameters: master"
        exit 1
}

# check required argument
if [ -z $master ] || [ -z $timethreshold ]; then
        usage
fi


# list of all old containers
# exclude sonargraph container from list
ACTIVEJENKINSSLAVES=`sudo docker ps --format "{{.ID}}#{{.Names}}#{{.Ports}}#{{.RunningFor}}" | grep "jenkins-slave" | grep "hours" | sed 's/ hours//g'`

for container in $ACTIVEJENKINSSLAVES; do
    time=`echo ${container} | sed 's/#/ /g' | awk '{print $4}'`
    echo "Checking Container ${container}"
    if (( "$time" > $timethreshold )); then 
        echo "Container ${container} is ${time} hours old and exceeds timethreshold of ${timethreshold} hours, try to remove..."
        # check if busy
        port=`echo ${container} | sed 's/#/ /g' | awk '{print $3}'`
        idle=`curl -s --data-urlencode script@idle_slaves.groovy $master/scriptText --user fsvctip:sommer11 |  grep ${port:8: -11} | wc -l`
        if [ "$idle" == "1" ]; then 
            container_id=`sudo docker ps | grep $port | awk '{print $1}'`
            echo "Stopping container with id=$container_id"
            sudo docker kill $container_id
            sudo docker rm $container_id
        fi
    fi
done
