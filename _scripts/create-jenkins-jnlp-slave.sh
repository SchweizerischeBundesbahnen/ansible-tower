#!/bin/bash -x
externalfshome=/var/lib/docker/container-ext-filesystems
randomint=`shuf -i 50000-60000 -n1`

# create container
sudo mkdir -p $externalfshome/$randomint/mavenrepo $externalfshome/$randomint/tmp $externalfshome/$randomint/workspace
sudo chown -R 1090:1090 $externalfshome/$randomint
sudo docker run -p $randomint:22 -d -m 50g -v "$externalfshome/$randomint/mavenrepo:/var/data/jenkins/m2/repository" -v "$externalfshome/$randomint/tmp:/tmp" -v "$externalfshome/$randomint/workspace:/var/data/jenkins/workspace" -e master=https://ci.sbb.ch -e executors=12 -e ciuser=fsvctip -e cipassword=sommer11 --name jenkins-slave-jee-jnlp-$randomint jenkins-slave-jee-jnlp
