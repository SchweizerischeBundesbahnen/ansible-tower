#! /bin/bash

sudo docker images | awk '{print $3}' | xargs --no-run-if-empty sudo docker rmi
