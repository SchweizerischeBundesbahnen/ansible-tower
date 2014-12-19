#!/bin/bash

error=0
tasklist=('base' 'jenkins-slave-base' 'stash-base' 'jira-standalone' 'stash-internal' 'jenkins-master' 'jenkins-slave-base' 'jenkins-slave-js' 'jenkins-slave-mobile-android' 'jenkins-slave-jee' 'jenkins-slave-wmb' 'jrebellicenseserver')

for task in "${tasklist[@]}"
do
  echo "$task"
  sudo docker build --rm=true --tag="schweizerischebundesbahnen/$task" ./$task/
  if [ $? -ne 0 ]; then
    echo "BUILD failed! Image=$task"
    error=1
    break;
  fi
done

exit $error
