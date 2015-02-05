#!/bin/bash -x
containerid=$1
externalfshome=/var/lib/docker/container-ext-filesystems

if [ ! -z $containerid ]
then
	# stop container
	sudo docker stop $containerid
	if [ $? -eq 0 ]
	then 

		# get fs id
		number=`sudo docker inspect -f='{{.Name}}' ${containerid} | awk -F "-" '{ print $NF }'`
		# remove container
		sudo docker rm $containerid
		# remove fs
		if [ -d $externalfshome/$number ]
		then
			sudo rm -rf $externalfshome/$number
		fi
	else
		echo "could not stop container with id ${containerid}"
		exit 1
	fi	
else
	echo "please provide a containerid"
fi
