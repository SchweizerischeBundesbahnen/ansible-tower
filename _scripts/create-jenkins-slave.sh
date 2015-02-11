#!/bin/bash -x

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
randomint=`shuf -i 50000-60000 -n1`

# create container
sudo mkdir -p $externalfshome/$randomint/mavenrepo $externalfshome/$randomint/tmp $externalfshome/$randomint/workspace $externalfshome/$randomint/.jenkins
sudo chown -R 1091:1091 $externalfshome/$randomint
sudo docker run --privileged -d -p $randomint:$randomint -v "$externalfshome/$randomint/mavenrepo:/var/data/jenkins/m2/repository" -v "$externalfshome/$randomint/tmp:/tmp" -v "$externalfshome/$randomint/workspace:/var/data/jenkins/workspace" -v "$externalfshome/$randomint/.jenkins:/var/data/jenkins/.jenkins" -e master=$master -e executors=1 -e ciuser=fsvctip -e cipassword=sommer11 -e slavename=$imagename-$randomint-`echo $HOSTNAME | cut -d"." -f1` -e labels=$labels -e externalport=$randomint -e host=$HOSTNAME --name $imagename-$randomint ${registry}/${imagename}:${tag}
