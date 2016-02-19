#!/bin/bash
#

set -x

GIT_BRANCH=$1
echo "GIT_BRANCH=${GIT_BRANCH}"

if [ -z "$GIT_BRANCH" ]; then
	echo "Please give me the current GIT_BRANCH"
	exit 1
fi

REGISTRY=registry.sbb.ch/kd_wzu

# since we're on a feature branch, we want to find the suffix
tag=`basename $GIT_BRANCH`
error=0

echo "TAG=${tag}"

#Find all files changed with respect to develop and order them breadth-first order
# http://stackoverflow.com/questions/539583/how-do-i-recursively-list-all-directories-at-a-location-breadth-first
filesTouched=`git show --pretty="format:" --name-only develop..${GIT_BRANCH} | perl -lne 'print tr:/::, " $_"' | sort -n | uniq | grep -v '^$' | cut -d' ' -f2 |  grep -v -E ".git|_doc|_scripts|configs"`

#For each folder, store only the path to the folder since only files are modified.
for f in $filesTouched ;
do
    dir=`dirname $f`;
    #If commit occurs in "config"-folder, treat it like it occured in the root-folder to pass the check against the folder-structure.
    base=`basename $dir`;
    if [ "$base" == "configs" ]; then
        dir=`dirname $dir`;
    fi
    #since git show respects the hierarchy, check if already touched folder is in list is sufficient to reduce any duplicates
    if [[ "$images" != *"$dir"* ]]; then
        if [[ -d "$dir" ]]; then
          #Exclude some folders from the search like .git, _scripts..everything where commits do not affect images should be ignored.
          #If directory does not exist any more, it's been git-mved away (in this case, it will show up in the list, too, so skip it in this case)
          images="$images `find $dir -type d -print | grep -v -E ".git|_doc|_scripts|configs" | grep -v "^.$" `";
        fi
    fi
done
#From here on, we have the images in a list depth-first order
images=`echo $images | tr -d "\n"`
#If a build occurs on an excluded folder, exit gracefully
if [ -z "$images" ]; then
    echo "images is empty, skipping build"
    exit 0
fi


#Build-PartStarting.
#Show what we build!
echo ""
echo ""
echo "-------------------------------------"
echo "Start if list of images to Build to push to ${REGISTRY}"
echo "-------------------------------------"
echo ""
echo ""
echo "${images}"
echo ""
echo ""
echo "-------------------------------------"
echo "End if list of images to Build to push to ${REGISTRY}, starting building and pushing"
echo "-------------------------------------"
echo ""
echo ""


#Getting the imagenames only for referring to dependant parents if necessary.
imagenames=`basename -a $images`
#Adapt the dockerfiles to point to registry and to point to adjacent parents included in this build, if necessary.
for path in $images ;
do
    echo ""
    echo ""
    echo "-------------------------------------"
    echo "Start of push and build of ${path}"
    echo "-------------------------------------"
    echo ""
    echo ""

    dockerfile=$path/Dockerfile
    image=`basename $path`
    parentimage=`grep "FROM" ${dockerfile} | cut -d/ -f3`

    # If the parent image is built too, then take the tagged image (which will already be built due to depth-first ordering); else take the untagged image
    # http://stackoverflow.com/questions/8063228/how-do-i-check-if-a-variable-exists-in-a-list-in-bash
    # Since 'base' is also part of 'jenkins-slave-base' etc, regex needs some complexity..., see http://stackoverflow.com/questions/9155590/regexp-match-character-group-or-end-of-line
    echo $imagenames | grep -q '\(^\|[ ]\)'$parentimage'\($\|[ ]\)'
    is_parent_built=$?
    echo "is_parent_built=${is_parent_built}"

    # is_parent_built is a integer. grep return 0 if, the pattern is found else 1. so if the parent image is found in $imagenames, then tag it with branch else take latest-dev
    if [[ ${is_parent_built} -eq 0 ]]; then
        echo "For image $image setting parent to  ${REGISTRY}\/$parentimage:${tag}"
		sed -ri "s#FROM ${REGISTRY}/$parentimage#FROM ${REGISTRY}/$parentimage:${tag}#g" ${dockerfile}
	else
        echo "For image $image setting parent to  ${REGISTRY}\/$parentimage:latest-dev"
		sed -ri "s#FROM ${REGISTRY}/$parentimage#FROM ${REGISTRY}/$parentimage:latest-dev#g" ${dockerfile}
    fi

    # build and push images
    echo "docker build --rm --no-cache -t ${REGISTRY}/${image}:${tag} ./${path}"
    sudo docker build --rm --no-cache -t ${REGISTRY}/${image}:${tag} ./${path}
    if [ $? -ne 0 ]; then
        echo "BUILD failed! Image=$image"
        exit -1
    fi

    echo "docker push ${REGISTRY}/${image}:${tag}"
    sudo docker push ${REGISTRY}/${image}:${tag}
    if [ $? -ne 0 ]; then
        echo "BUILD failed! Pushing image=$image failed!"
        exit -3
    fi

    # delete images from disk, if succesful. Exit otherwise
    if [ $error -eq 0 ]; then
        sudo docker rmi -f "${REGISTRY}/${image}:${tag}"
    else
        exit $error
    fi

    echo ""
    echo ""
    echo "-------------------------------------"
    echo "End of push and build of ${path}"
    echo "-------------------------------------"
    echo ""
    echo ""
done
exit $error