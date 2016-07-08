#!/bin/bash

###########################################################################
# File: create-jenkins-slave.sh
# Description: create a jenkins Docker slave from the internal Docker repo:
# - registry (e.g. "registry-t.sbb.ch"
# - imagename (e.g. "jenkins-slave-android")
# - tag (e.g "WZU-2994")
# - master url (e.g. "https://ci.sbb.ch")
# - labels (e.g. "android")
###########################################################################

registry=$1
imagename=$2
tag=$3
master=$4
labels=$5
additional_args=$6
randomint=`shuf -i 40000-65000 -n1`
master_hostname=`echo $master | awk -F/ '{print $3}' | awk -F: '{print $1}'`
android_memory_limit=20g

# how many executors per kind of slave
declare -A execount
execount[java]=1
execount[android]=1
execount[sonargraph]=5

# repolink parameter
REPO_LINK="--link repocache:repo.sbb.ch"

containername=$imagename-$randomint-$master_hostname
slavename=${imagename:14}-$randomint-`echo $HOSTNAME | cut -d"." -f1`-$tag



function checkVarnish() {
  VARNISHNAME=repocache
  sudo ./check-docker-container.sh ${VARNISHNAME}
	if [ $? -gt 0 ]; then
    echo "No varnish running! Starting jenkins slave without repo link"
    unset REPO_LINK
	fi
}


function check_reserved() {

        USED_PORTS=`netstat -ln | grep ':$randomint ' | grep LISTEN | wc -l`

        while [ $USED_PORTS -gt 0 ]
        do
                randomint=`shuf -i 40000-65000 -n1`
                USED_PORTS=`netstat -ln | grep ':$randomint ' | grep LISTEN | wc -l`
        done
}

function create_android_container() {
	sudo docker run --privileged -d ${REPO_LINK} -p $randomint:$randomint --memory=$android_memory_limit -e master=$master -e executors=${execount["$labels"]} -e ciuser=fsvctip -e cipassword=sommer11 -e slavename=$slavename -e externalport=$randomint -e host=$HOSTNAME -e additional_args="${additional_args}" --name $containername ${registry}/${imagename}:${tag}
}

function create_privileged_container() {
	sudo docker run --privileged -d ${REPO_LINK} -p $randomint:$randomint -e master=$master -e executors=${execount["$labels"]} -e ciuser=fsvctip -e cipassword=sommer11 -e slavename=$slavename  -e externalport=$randomint -e host=$HOSTNAME -e additional_args="${additional_args}" --name $containername ${registry}/${imagename}:${tag}
}

function create_container() {
	if [ "$labels" == "sonargraph" ]
	then
		containername=$labels-$randomint-$master_hostname
		slavename=$labels-$randomint-`echo $HOSTNAME | cut -d"." -f1`
	fi
        sudo docker run -d ${REPO_LINK} -p $randomint:$randomint -e master=$master -e executors=${execount["$labels"]} -e ciuser=fsvctip -e cipassword=sommer11 -e slavename=$slavename -e externalport=$randomint -e host=$HOSTNAME -e additional_args="${additional_args}" --name $containername ${registry}/${imagename}:${tag}
}

function usage() {
	echo "You need to provide the following parameters: registry imagename tag master labels"
	exit 1
}

if [ -z $registry ] || [ -z $imagename ] || [ -z $tag ] || [ -z $master ] || [ -z $labels ]
then
        usage
fi

check_reserved

checkVarnish

if [[ $imagename =~ .*android.* ]]
then
        create_android_container
else
        create_container
fi

