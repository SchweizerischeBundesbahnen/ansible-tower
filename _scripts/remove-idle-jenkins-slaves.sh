#!/bin/bash
#
# Removes old and idle slaves from slave host. Takes at least one argument: the ci master url
# The second optional argument is for the automatic rollover and is just a definition of "old"
#


# which master to use
master=$1

# default definition of old
old=" days"


function usage() {
        echo "You need to provide the following parameters: master"
        exit 1
}

# check required argument
if [ -z $master ]; then
        usage
fi

# optional argument
if [ $# -eq 2 ]; then
        old=${2}
fi



# list of all old containers
# exclude sonargraph container from list
OLD_CONTAINERS=`sudo docker ps | grep "$old" | grep -v "sonargraph" | grep "jenkins-slave" | awk '{print $13}'`

for container in $OLD_CONTAINERS; do

  #echo "processing: $container"
  
  # check if busy
  idle=`curl -s --data-urlencode script@idle_slaves.groovy $master/scriptText --user fsvctip:sommer11 |  grep ${container:8: -11} | wc -l`
  if [ "$idle" == "1" ]; then 
    container_id=`sudo docker ps | grep $container | awk '{print $1}'`
    echo "stopping container with id=$container_id"

    sudo docker kill $container_id
    sudo docker rm $container_id
  fi

done
