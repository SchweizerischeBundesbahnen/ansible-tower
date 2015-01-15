#!/bin/bash

# Execute via ssh from Jenkins on the Docker Builder Slave
# N.B. The environment Variables GIT_BRANCH and GIT_COMMIT are set by the Jenkins Git Plugin,
# see https://wiki.jenkins-ci.org/display/JENKINS/Git+Plugin

echo "GIT_URL=${GIT_URL}"
echo "GIT_COMMIT=${GIT_COMMIT}"
echo "GIT_BRANCH=${GIT_BRANCH}"


exit

git clone ${GIT_URL}
git checkout "${GIT_BRANCH}"
cd _scripts
chmod u+x
GIT_COMMIT="`git rev-parse HEAD`"
./build_and_push_preproc.sh "${GIT_COMMIT}" "${GIT_BRANCH}"




tag="latest"

rm -fR wzu-docker
git clone https://code.sbb.ch/scm/kd_wzu/wzu-docker.git
git checkout $branch





# for testing...
feature_branch="refs/heads/$branch"

# if we're not on a feature branch...
if  [[ $feature_branch != *feature* ]]
then
    pr="`python extract_open_pull_request_id.py ${feature_branch} ${GIT_COMMIT}`"
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
registry="registry-t.sbb.ch"
case $branch in
  "master")
    registry="registry.sbb.ch"
  ;;
  "develop")
    registry="registry-i.sbb.ch"
  ;;
  *)
    registry="registry-t.sbb.ch"
  ;;
esac

# call build_and_push
./build_and_push.sh ${registry} ${tag}

