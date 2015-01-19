#!/bin/bash -x

###########################################################################
# File: create-jenkins-slave.sh
# Description: create a jenkins Docker slave from the internal Docker repo:
# - imagename (e.g. "jenkins-slave-mobile-android")
# - master url (e.g. "https://ci.sbb.ch")
# - labels (e.g. "android")
###########################################################################

imagename=$1
master=$2
labels=$3

externalfshome=/var/data/docker/container-ext-filesystems
randomint=`shuf -i 50000-60000 -n1`

# create container
sudo mkdir -p $externalfshome/$randomint/mavenrepo $externalfshome/$randomint/tmp $externalfshome/$randomint/workspace $externalfshome/$randomint/.jenkins
sudo chown -R 1091:1091 $externalfshome/$randomint
sudo docker run --privileged -d -v "$externalfshome/$randomint/mavenrepo:/var/data/jenkins/m2/repository" -v "$externalfshome/$randomint/tmp:/tmp" -v "$externalfshome/$randomint/workspace:/var/data/jenkins/workspace" -v "$externalfshome/$randomint/.jenkins:/var/data/jenkins/.jenkins" -e master=$master -e executors=1 -e ciuser=fsvctip -e cipassword=sommer11 -e labels=$labels --name $imagename-$randomint schweizerischebundesbahnen/$imagename