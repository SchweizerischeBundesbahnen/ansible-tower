#!/bin/bash

###########################################################################
# File: create-jenkins-slave.sh
# Description: create a jenkins Docker slave from the internal Docker repo:
# - registry (e.g. "registry-t.sbb.ch"
# - imagename (e.g. "jenkins-slave-mobile-android")
# - tag (e.g "WZU-2994")
# - master url (e.g. "https://ci.sbb.ch")
# - labels (e.g. "android")
###########################################################################

registry=$1
imagename=$2
tag=$3
master=$4
labels=$5
externalfshome=/var/data/docker/container-ext-filesystems
randomint=`shuf -i 40000-65000 -n1`

function check_reserved() {
	while [ -d $externalfshome/$randomint ]
	do	
		randomint=`shuf -i 40000-65000 -n1`
	done	
}

function create_directories() {
	sudo mkdir -p $externalfshome/$randomint/mavenrepo $externalfshome/$randomint/tmp $externalfshome/$randomint/workspace $externalfshome/$randomint/.jenkins $externalfshome/$randomint/temp $externalfshome/$randomint/.sonar
        sudo chown -R 1091:1091 $externalfshome/$randomint
}

function create_privileged_container() {
	sudo docker run --privileged -d -p $randomint:$randomint -v "$externalfshome/$randomint/mavenrepo:/var/data/jenkins/m2/repository" -v "$externalfshome/$randomint/tmp:/tmp" -v "$externalfshome/$randomint/workspace:/var/data/jenkins/workspace" -v "$externalfshome/$randomint/.jenkins:/var/data/jenkins/.jenkins" -v "$externalfshome/$randomint/temp:/var/data/jenkins/temp" -v "$externalfshome/$randomint/.sonar:/var/data/jenkins/.sonar" -e master=$master -e executors=1 -e ciuser=fsvctip -e cipassword=sommer11 -e slavename=$imagename-$randomint-`echo $HOSTNAME | cut -d"." -f1` -e labels=$labels -e externalport=$randomint -e host=$HOSTNAME --name $imagename-$randomint ${registry}/${imagename}:${tag}
}

function create_container() {
        sudo docker run -d -p $randomint:$randomint -v "$externalfshome/$randomint/mavenrepo:/var/data/jenkins/m2/repository" -v "$externalfshome/$randomint/tmp:/tmp" -v "$externalfshome/$randomint/workspace:/var/data/jenkins/workspace" -v "$externalfshome/$randomint/.jenkins:/var/data/jenkins/.jenkins" -v "$externalfshome/$randomint/temp:/var/data/jenkins/temp" -v "$externalfshome/$randomint/.sonar:/var/data/jenkins/.sonar" -e master=$master -e executors=1 -e ciuser=fsvctip -e cipassword=sommer11 -e slavename=$imagename-$randomint-`echo $HOSTNAME | cut -d"." -f1` -e labels=$labels -e externalport=$randomint -e host=$HOSTNAME --name $imagename-$randomint ${registry}/${imagename}:${tag}
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
create_directories

if [[ $imagename =~ .*android.* ]]
then
        create_privileged_container
else
        create_container
fi

