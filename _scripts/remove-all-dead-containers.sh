#! /bin/bash

docker ps --all | grep Exited | cut -d " " -f 1 | xargs --no-run-if-empty docker rm
