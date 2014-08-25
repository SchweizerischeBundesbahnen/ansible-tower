#!/bin/bash -x
externalfshome=/var/lib/docker/container-ext-filesystems
randomint=$RANDOM

# create container
sudo mkdir -p $externalfshome/$randomint/mavenrepo $externalfshome/$randomint/tmp $externalfshome/$randomint/workspace
sudo chown -R 500:500 $externalfshome/$randomint
sudo docker run -d -m 16g -v "$externalfshome/$randomint/mavenrepo:/var/data/jenkins/m2/repository" -v "$externalfshome/$randomint/tmp:/tmp" -v "$externalfshome/$randomint/workspace:/var/data/jenkins/workspace" -e master=https://ci.sbb.ch jenkins-slave-jee
