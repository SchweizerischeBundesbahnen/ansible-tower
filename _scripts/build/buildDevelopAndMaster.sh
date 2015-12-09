#!/bin/bash
#

GIT_BRANCH=$1
git checkout "${GIT_BRANCH}"

GIT_COMMIT_BEFORE_LAST=`git log --pretty=format:"%H" |head -2 | tail -1`
echo "GIT_COMMIT_BEFORE_LAST=${GIT_COMMIT_BEFORE_LAST}"

LATEST_TAG_NAME=latest-int

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
    exit -1
fi

# define registry to push to
REGISTRY="registry.sbb.ch"

echo ""
echo ""
echo "-------------------------------------"
echo "Start if list of images to Build to push to $REGISTRY"
echo "-------------------------------------"
echo ""
echo ""
FILELIST=`find base -type d -print | grep -v -E ".git|_doc|_scripts|configs"`
echo "$FILELIST"
echo ""
echo ""
echo "-------------------------------------"
echo "End if list of images to Build to push to $REGISTRY, starting building and pushing"
echo "-------------------------------------"
echo ""
echo ""


for TOBUILD in $FILELIST ; 
do
    echo ""
    echo ""
    echo "-------------------------------------"
    echo "Start of push and build of ${TOBUILD}"
    echo "-------------------------------------"
    echo ""
    echo ""
    
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
    echo "docker build --rm --no-cache -t ${REGISTRY}/${IMAGE}:${TAG} ./${TOBUILD}"
    sudo docker build --rm --no-cache -t ${REGISTRY}/${IMAGE}:${TAG} ./${TOBUILD}
    if [ $? -ne 0 ]; then
        echo "BUILD failed! Image=$IMAGE"
        exit -1
    fi

    echo "docker push ${REGISTRY}/${IMAGE}:${TAG}"
    sudo docker push ${REGISTRY}/${IMAGE}:${TAG}
    if [ $? -ne 0 ]; then

        echo "BUILD failed! Pushing image=$IMAGE failed!"
        exit -3
    fi

    echo "setting latest tag for ${IMAGE}:${TAG}"
    sudo docker tag -f "${REGISTRY}/${IMAGE}:${TAG}" "${REGISTRY}/${IMAGE}:${LATEST_TAG_NAME}"
    sudo docker push ${REGISTRY}/${IMAGE}:${LATEST_TAG_NAME}
    if [ $? -ne 0 ]; then
            echo "BUILD failed! Pushing image=$IMAGE failed!"
            exit -4
    fi
    
    echo ""
    echo ""
    echo "-------------------------------------"
    echo "End of push and build of ${TOBUILD}"
    echo "-------------------------------------"
    echo ""
    echo ""
done


# if we reach this point, everything went fine and we can delete all images
echo ""
echo ""
echo "-------------------------------------"
echo "Delete all images"
echo "-------------------------------------"
echo ""
echo ""
for TOBUILD in $FILELIST ;
do
  IMAGE=`basename ${TOBUILD}`
  echo "Deleting ${IMAGE}"
  sudo docker rmi -f ${REGISTRY}/${IMAGE}:${LATEST_TAG_NAME}
  sudo docker rmi -f ${REGISTRY}/${IMAGE}:${TAG}
done
