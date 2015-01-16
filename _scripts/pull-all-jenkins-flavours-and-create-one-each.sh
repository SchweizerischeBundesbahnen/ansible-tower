#!/bin/bash

tag=$1
if [[ ! -z "$tag" ]]; then
    tag="schweizerischebundesbahnen"
fi

error=0
tasklist=('jenkins-slave-base' 'jenkins-slave-js' 'jenkins-slave-mobile-android' 'jenkins-slave-jee' 'jenkins-slave-wmb')

for task in "${tasklist[@]}"
do
  echo "$task"
  sudo docker pull "$tag/$task"
  if [ $? -ne 0 ]; then
    echo "PULL failed! Image=$tag/$task"
    error=1
    break;
  fi
done

exit $error