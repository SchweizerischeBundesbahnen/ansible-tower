#!/bin/bash
#
# Just for the case that the latest tag is not correctly set: This script sets the latest 
# tag on registry.sbb.ch to the configured TAG id below!
# 

# The tag to use as latest
TAG=47

# generate image list
MODULE_LIST=`find . -type d -print | grep -v -E ".git|_doc|_scripts|configs"`

for image in $MODULE_LIST; do
	
	image=`basename $image`
	echo $image
	sudo docker pull registry.sbb.ch/$image:$TAG
	sudo docker tag registry.sbb.ch/$image:$TAG registry.sbb.ch/$image:latest
	sudo docker push registry.sbb.ch/$image:latest
done
