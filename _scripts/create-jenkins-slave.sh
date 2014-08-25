#!/bin/bash -x
externalfshome=/var/lib/docker/container-ext-filesystems
randomint=$RANDOM

# create container
sudo mkdir -p $externalfshome/$randomint/mavenrepo $externalfshome/$randomint/tmp $externalfshome/$randomint/workspace
sudo chown -R 1090:1090 $externalfshome/$randomint
sudo docker run -d -m 4g -v "$externalfshome/$randomint/mavenrepo:/var/data/jenkins/m2/repository" -v "$externalfshome/$randomint/tmp:/tmp" -v "$externalfshome/$randomint/workspace:/var/data/jenkins/workspace" -e master=https://ci.sbb.ch jenkins-slave-jee -e executors=1
