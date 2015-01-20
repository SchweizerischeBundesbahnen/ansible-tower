#!/bin/bash -x
containerid=$1
externalfshome=/var/data/docker/container-ext-filesystems

# stop container
sudo docker stop $containerid

# get fs id
fsid=`sudo docker inspect -f='{{.Name}}' ${containerid} | awk -F"-" '{print $NF }'`

# remove container
sudo docker rm $containerid

# remove fs
if [[ ! -z "$fsid" ]]; then
    sudo rm -rf $externalfshome/$fsid
fi

