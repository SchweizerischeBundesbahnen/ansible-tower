#!/bin/bash
#
# This script rolls out new jenkins slave images and tags them to latest. 
# Normally this script is called by upstream master docker Build job but 
# if it has the NEW_TAG as second argument ist will also be usable directly
# 
# Usage:
# Jenkins Job: ./deployLatestImages.sh origin/master
# Manual run:  ./deployLatestImages.sh origin/master 666 
#



# Get PR from branch
function getPR() {
	GIT_BRANCH=$1
	git checkout "${GIT_BRANCH}"

	GIT_COMMIT_BEFORE_LAST=`git log --pretty=format:"%H" |head -2 | tail -1`

	# Finding the pull request based on the commit via Stash
	BRANCH=`basename $GIT_BRANCH`
	PR="`python _scripts/build/extract_open_pull_request_id.py "refs/heads/${BRANCH}" ${GIT_COMMIT_BEFORE_LAST}`"

	# validate id
	if [[ ${PR} =~ ^-?[0-9]+$ ]]
	then
	    echo "${PR}"
	else
	    echo "pr=${PR} is NOT valid, exiting..."
	    exit -1
	fi
}

# check arguments, only try to get PR if arg count=1
echo "$0 started with arguments:"
echo "1: $1"
echo "2: $2"
if [ "$#" -eq 1 ]; then 
	NEW_TAG=`getPR ${1}`
	echo "TAG=${NEW_TAG}"
elif [ "$#" -eq 2 ]; then
	NEW_TAG=${2}
fi

echo "Will deploy tag=${NEW_TAG} as latest on this docker host"

# pull current images
sudo docker pull registry.sbb.ch/kd_wzu/jenkins-slave-java:${NEW_TAG}
sudo docker pull registry.sbb.ch/kd_wzu/jenkins-slave-was85:${NEW_TAG}
sudo docker pull registry.sbb.ch/kd_wzu/jenkins-slave-js:${NEW_TAG}
sudo docker pull registry.sbb.ch/kd_wzu/jenkins-slave-mobile-android:${NEW_TAG}

# set latest tag
sudo docker tag -f registry.sbb.ch/kd_wzu/jenkins-slave-java:${NEW_TAG} registry.sbb.ch/kd_wzu/jenkins-slave-java:latest
sudo docker tag -f registry.sbb.ch/kd_wzu/jenkins-slave-was85:${NEW_TAG} registry.sbb.ch/kd_wzu/jenkins-slave-was85:latest
sudo docker tag -f registry.sbb.ch/kd_wzu/jenkins-slave-js:${NEW_TAG} registry.sbb.ch/kd_wzu/jenkins-slave-js:latest
sudo docker tag -f registry.sbb.ch/kd_wzu/jenkins-slave-mobile-android:${NEW_TAG} registry.sbb.ch/kd_wzu/jenkins-slave-mobile-android:latest
  

