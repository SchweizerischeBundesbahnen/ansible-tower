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

# cleanup and get fresh code
rm -fR wzu-docker
git clone ${GIT_URL}
cd wzu-docker
git checkout "${GIT_BRANCH}"

GIT_COMMIT_BEFORE_LAST=`git log --pretty=format:"%H" |head -2 | tail -1`
echo "GIT_COMMIT_BEFORE_LAST=${GIT_COMMIT_BEFORE_LAST}"




# if we're not on a feature branch, we want to find the pull request
tag=`basename $GIT_BRANCH`
echo "tag=${tag}"
if  [[ $GIT_BRANCH != *feature* ]]
then
    pr="`python _scripts/extract_open_pull_request_id.py "refs/heads/${tag}" ${GIT_COMMIT_BEFORE_LAST}`"
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
else
    # feature branch: build only if we have changes in a docker module!
    echo "Building a feature branch: checking changed files"
    git diff-tree --no-commit-id --name-only -r ${GIT_COMMIT_BEFORE_LAST}
    
    CHANGED_FILE_COUNT=`git diff-tree --no-commit-id --name-only -r ${GIT_COMMIT_BEFORE_LAST} | grep -v -w '_scripts\|_doc' | wc -l`
    echo "Filtered file list count: "
    echo "${CHANGED_FILE_COUNT}"

    if [ ${CHANGED_FILE_COUNT} -eq 0 ]; then
      echo "No Docker module files changed! Build not required!"
      exit 0
    else
      echo "There are changed docker modules!"
    fi

fi

echo "TAG=${tag}"



# define registry to push to
# feature -> registry-t
# branch develop -> registry-i
# branch master -> registry
# (pattern matching in case statements: http://docstore.mik.ua/orelly/unix3/upt/ch35_11.htm)
branch=`basename $GIT_BRANCH`
registry="registry-t.sbb.ch"
case $branch in
  *master)
    registry="registry.sbb.ch"
  ;;
  *develop)
    registry="registry-i.sbb.ch"
  ;;
  *)
    registry="registry-t.sbb.ch"
  ;;
esac

# call build_and_push
_scripts/build_and_push.sh ${registry} ${tag}

