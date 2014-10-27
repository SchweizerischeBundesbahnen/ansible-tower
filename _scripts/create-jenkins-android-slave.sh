#!/bin/bash -x
externalfshome=/var/lib/docker/container-ext-filesystems
randomint=`shuf -i 50000-60000 -n1`

# create container
sudo mkdir -p $externalfshome/$randomint/mavenrepo $externalfshome/$randomint/tmp $externalfshome/$randomint/workspace $externalfshome/$randomint/.jenkins
sudo chown -R 1091:1091 $externalfshome/$randomint
sudo docker run --privileged -p $randomint:22 -d -v "$externalfshome/$randomint/mavenrepo:/var/data/jenkins/m2/repository" -v "$externalfshome/$randomint/tmp:/tmp" -v "$externalfshome/$randomint/workspace:/var/data/jenkins/workspace" -v "$externalfshome/$randomint/.jenkins:/var/data/jenkins/.jenkins" -e master=http://ci-t.sbb.ch -e executors=1 -e ciuser=fsvctip -e cipassword=sommer11 --name jenkins-slave-android-$randomint schweizerischebundesbahnen/jenkins-slave-mobile-android 
