#!/bin/bash
#

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
    TAG=${PR}
else
    echo "pr=${PR} is NOT valid, exiting..."
    TAG=89
fi

# define registry to push to
# branch develop -> registry-i
# branch master -> registry
# everything else -> fail
# (pattern matching in case statements: http://docstore.mik.ua/orelly/unix3/upt/ch35_11.htm)
REGISTRY="INVALID"
case $BRANCH in
  *master)
    REGISTRY="registry.sbb.ch"
  ;;
  *develop)
    REGISTRY="registry-i.sbb.ch"
  ;;
  *)
    REGISTRY="INVALID"
  ;;
esac

#Check if we are on a valid branch (develop or master)
if [ "$REGISTRY" = "INVALID" ]; then
    echo "Branch $GIT_BRANCH invalid, exiting..."
    exit -1
fi

FILELIST=`find base -type d -print | grep -v -E ".git|_doc|_scripts|configs"`
echo "Building the following images: $FILELIST"

for TOBUILD in $FILELIST 
do
    DOCKERFILE=$TOBUILD/Dockerfile
    SEARCH=`grep "FROM schweizerischebundesbahnen" ${DOCKERFILE}`
    echo "Dockerfile: ${DOCKERFILE}"
    echo "Old from: ${SEARCH}"
    sed -ri "s#${SEARCH}#${SEARCH}:${TAG}#g" ${DOCKERFILE}
    sed -ri "s#schweizerischebundesbahnen#${REGISTRY}#g" ${DOCKERFILE}
    SEARCH=`grep "FROM ${REGISTRY}" ${DOCKERFILE}`
    echo "New from: ${SEARCH}"

    IMAGE=`basename $TOBUILD`

    # build and push images
    echo "Cleaning up possibly existing images for schweizerischebundesbahnen/${IMAGE}:${TAG}"
    sudo docker rmi -f schweizerischebundesbahnen/${IMAGE}:${TAG} && true
    echo "docker build --rm --no-cache -t schweizerischebundesbahnen/${IMAGE}:${TAG} ./${TOBUILD}"
    sudo docker build --rm --no-cache -t schweizerischebundesbahnen/${IMAGE}:${TAG} ./${TOBUILD}
    if [ $? -ne 0 ]; then
        echo "BUILD failed! Image=$IMAGE"
        exit -1
    fi

    # if everything is ok till now: push images to internal registry
    echo "docker tag -f "schweizerischebundesbahnen/${IMAGE}:${TAG}" "${REGISTRY}/${IMAGE}:${TAG}""
    sudo docker tag "schweizerischebundesbahnen/${IMAGE}:${TAG}" "${REGISTRY}/${IMAGE}:${TAG}"
    if [ $? -ne 0 ]; then
        echo "BUILD failed! Tagging image=$IMAGE failed!"
           exit -2
    fi

    echo "docker push ${REGISTRY}/${IMAGE}:${TAG}"
    sudo docker push ${REGISTRY}/${IMAGE}:${TAG}
    if [ $? -ne 0 ]; then
        echo "BUILD failed! Pushing image=$IMAGE failed!"
        exit -3
    fi

    echo "setting latest tag for ${IMAGE}:${TAG}"
    sudo docker tag -f "schweizerischebundesbahnen/${IMAGE}:${TAG}" "${REGISTRY}/${IMAGE}:latest"
    sudo docker push ${REGISTRY}/${IMAGE}:latest
    if [ $? -ne 0 ]; then
            echo "BUILD failed! Pushing image=$IMAGE failed!"
            exit -4
    fi

done

