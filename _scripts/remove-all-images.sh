#! /bin/bash

docker images | grep "^<none>" | awk '{print $3}' | xargs --no-run-if-empty docker rmi
