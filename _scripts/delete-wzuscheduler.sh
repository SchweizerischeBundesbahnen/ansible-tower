#!/bin/bash
CONTAINER=$(docker ps)
if [[ $CONTAINER == *wzuscheduler* ]]
then
        CONTAINERID=$(docker ps -q)
        sudo docker stop $CONTAINERID
        sleep 3
        echo "Container stopped"
        sudo docker rm $CONTAINERID
        echo "Container deleted"
else
        echo "No Running WZUScheduler found"
        exit 1
fi
