#!/bin/bash -x
containerid=$1
externalfshome=/var/data/docker/container-ext-filesystems

# stop container
sudo docker stop $containerid

# get fs id
fsid=`sudo docker inspect -f='{{.Volumes}}' ${containerid} | cut -d"/" -f7`

# remove container
sudo docker rm $containerid

# remove fs
sudo rm -rf $externalfshome/$fsid

