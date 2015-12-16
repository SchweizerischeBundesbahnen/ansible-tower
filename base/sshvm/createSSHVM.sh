#!/bin/bash

# usage: takes one argument: project
# project will be used as basedirectory for external data and container name

BASE_DIR=/var/data
RESOURCE_LIMITS="-m 512m --cpuset-cpus='1'"

if [ $# -eq 0 ]; then
  echo "Usage: $0 projectname"
  echo "Sample for sagra: $0 sagra"
  exit 1
fi

# create directory structure
PROJECT_DIR=${BASE_DIR}/$1
if [ ! -d "${PROJECTDIR}" ]; then
  mkdir -p ${PROJECT_DIR}/data
  mkdir -p ${PROJECT_DIR}/opt
fi

# run
#sudo docker run -p 10022:22 -p 10080:80 -d --name sshvm registry.sbb.ch/sshvm

# run with external volumes
sudo docker run ${RESOURCE_LIMITS} -p 10022:22 -p 10080:80 -v ${PROJECT_DIR}/data:/var/data -v ${PROJECT_DIR}/opt/:/opt -d --restart=always --name sshvm-$1 registry.sbb.ch/sshvm
