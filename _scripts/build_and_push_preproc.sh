#!/bin/bash

# Find the input parameters
commit_hash=$1
branch=$2

echo "commit_hash=${commit_hash}"
echo "branch=${branch}"

tag="latest"

exit

rm -fR wzu-docker
git clone https://code.sbb.ch/scm/kd_wzu/wzu-docker.git
git checkout $branch





# for testing...
feature_branch="refs/heads/$branch"

# if we're not on a feature branch...
if  [[ $feature_branch != *feature* ]]
then
    pr="`python extract_open_pull_request_id.py ${feature_branch} ${commit_hash}`"
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

