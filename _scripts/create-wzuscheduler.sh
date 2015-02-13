#!/bin/bash -x
externalfshome=/var/data/wzuscheduler/container-ext-filesystems
# create container
sudo mkdir -p $externalfshome/jenkins $externalfshome/tmp
sudo chown -R 1090:1090 $externalfshome
sudo docker run -p 8080:8080 -d -m 3072m -v "$externalfshome/tmp:/tmp" -v "$externalfshome/jenkins:/var/data/jenkins" -e executors=3 --name wzuscheduler-t wzuscheduler
if [ $? -gt 0 ]; then
    echo "If there is a wzuscheduler image left, you can use service wzuscheduler forcestop"
fi
