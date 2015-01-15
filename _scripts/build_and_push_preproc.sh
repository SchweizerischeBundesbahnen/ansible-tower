#!/bin/bash

# Execute via ssh from Jenkins on the Docker Builder Slave
# N.B. The environment Variables from the Jenkins Git Plugin are not forward to the environment in which this script is executed.
# List of available variables in Jenkins Exec, see https://wiki.jenkins-ci.org/display/JENKINS/Git+Plugin
GIT_URL=$1
GIT_COMMIT=$2
GIT_BRANCH=$3

echo "GIT_URL=${GIT_URL}"
echo "GIT_COMMIT=${GIT_COMMIT}"
echo "GIT_BRANCH=${GIT_BRANCH}"

rm -fR wzu-docker
git clone ${GIT_URL}
cd wzu-docker/_scripts
git checkout "${GIT_BRANCH}"




tag="latest"



# if we're not on a feature branch...
if  [[ $GIT_BRANCH != *feature* ]]
then
    pr="`python extract_open_pull_request_id.py ${GIT_BRANCH} ${GIT_COMMIT}`"
    echo "pr=${pr}"

    # validate id
    if [[ ${pr} =~ ^-?[0-9]+$ ]]
    then
        echo "pr=${pr} is valid!"
	tag=${pr}
    else 
	echo "pr=${pr} is NOT valid!"
	exit -1
    fi
fi

# define registry to push to
# feature -> registry-t
# branch develop -> registry-i
# branch master -> registry
# (pattern matching in case statements: http://docstore.mik.ua/orelly/unix3/upt/ch35_11.htm)
registry="registry-t.sbb.ch"
case $branch in
  "*master)")
    registry="registry.sbb.ch"
  ;;
  "*develop)")
    registry="registry-i.sbb.ch"
  ;;
  *)
    registry="registry-t.sbb.ch"
  ;;
esac

# call build_and_push
./build_and_push.sh ${registry} ${tag}

