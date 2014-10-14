#!/bin/bash
CONTAINER=$(docker ps -a)
if [[ $CONTAINER == *wzuscheduler* ]]
then
        CONTAINERID=$(docker ps -q)
        sudo docker stop $CONTAINERID
        sleep 3
        sudo docker rm $CONTAINERID
        echo "Container deleted"
else
        echo "No WZUScheduler found"
        exit 1
fi
