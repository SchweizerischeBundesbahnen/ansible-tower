#!/bin/bash
#

GIT_BRANCH=$1
echo "GIT_BRANCH=${GIT_BRANCH}"

REGISTRY=registry.sbb.ch

# since we're on a feature branch, we want to find the suffix
tag=`basename $GIT_BRANCH`
error=0

echo "TAG=${tag}"

#Find all files changed with respect to develop and order them breadth-first order
# http://stackoverflow.com/questions/539583/how-do-i-recursively-list-all-directories-at-a-location-breadth-first
filesTouched=`git show --pretty="format:" --name-only develop..${GIT_BRANCH} | perl -lne 'print tr:/::, " $_"' | sort -n | uniq | grep -v '^$' | cut -d' ' -f2`

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
          images="$images `find $dir -type d -print | grep -v -E ".git|_doc|_scripts|configs"`";
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
previousimage=NOIMAGE
#Adapt the dockerfiles to point to registry-t and to point to adjacent parents included in this build, if necessary.
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
    
    if [ $previousimage == "NOIMAGE" ]; then
		sed -ri "s#FROM schweizerischebundesbahnen#FROM ${REGISTRY}#g" ${dockerfile}
	else
		sed -ri "s#FROM schweizerischebundesbahnen\/$previousimage#FROM ${REGISTRY}\/$previousimage:${tag}#g" ${dockerfile}
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
    
    previousimage=$image

    echo ""
    echo ""
    echo "-------------------------------------"
    echo "End of push and build of ${TOBUILD}"
    echo "-------------------------------------"
    echo ""
    echo ""
done
exit $error
