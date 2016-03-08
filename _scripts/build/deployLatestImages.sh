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
	echo "GIT_COMMIT_BEFORE_LAST=${GIT_COMMIT_BEFORE_LAST}"

	# Finding the pull request based on the commit via Stash
	BRANCH=`basename $GIT_BRANCH`
	echo "branch=${BRANCH}"
	PR="`python _scripts/build/extract_open_pull_request_id.py "refs/heads/${BRANCH}" ${GIT_COMMIT_BEFORE_LAST}`"

	# validate id
	if [[ ${PR} =~ ^-?[0-9]+$ ]]
	then
	    echo "pr=${PR} is valid, used as tag"
	    NEW_TAG=${PR}
	else
	    echo "pr=${PR} is NOT valid, exiting..."
	    exit -1
	fi

	echo ${PR}
}

# check arguments, only try to get PR if arg count=1
if [ "$#" -eq 1 ]; then 
	NEW_TAG=`getPR ${1}`
elif [ "$#" -eq 2 ]; then
	NEW_TAG=${2}
fi

echo "Will deploy tag=${NEW_TAG} as latest on this docker host"

# pull current images
sudo docker pull registry.sbb.ch/kd_wzu/jenkins-slave-base:${NEW_TAG}
sudo docker pull registry.sbb.ch/kd_wzu/jenkins-slave-was85:${NEW_TAG}
sudo docker pull registry.sbb.ch/kd_wzu/jenkins-slave-wmb:${NEW_TAG}
sudo docker pull registry.sbb.ch/kd_wzu/jenkins-slave-js:${NEW_TAG}
sudo docker pull registry.sbb.ch/kd_wzu/jenkins-slave-mobile-android:${NEW_TAG}

# set latest tag
sudo docker tag -f registry.sbb.ch/kd_wzu/jenkins-slave-base:${NEW_TAG} registry.sbb.ch/kd_wzu/jenkins-slave-base:latest
sudo docker tag registry.sbb.ch/kd_wzu/jenkins-slave-was85:${NEW_TAG} registry.sbb.ch/kd_wzu/jenkins-slave-was85:latest
sudo docker tag registry.sbb.ch/kd_wzu/jenkins-slave-wmb:${NEW_TAG} registry.sbb.ch/kd_wzu/jenkins-slave-wmb:latest
sudo docker tag registry.sbb.ch/kd_wzu/jenkins-slave-js:${NEW_TAG} registry.sbb.ch/kd_wzu/jenkins-slave-js:latest
sudo docker tag -f registry.sbb.ch/kd_wzu/jenkins-slave-mobile-android:${NEW_TAG} registry.sbb.ch/kd_wzu/jenkins-slave-mobile-android:latest
  

