#!/bin/bash
#

GIT_BRANCH=$1

echo "STATIC BUILD SCRIPT"
echo "GIT_BRANCH=${GIT_BRANCH}"

# since we're on a feature branch, we want to find the suffix
tag=`basename $GIT_BRANCH`
error=0

echo "TAG=${tag}"

#Find out what to build
#Order is always respecting hierarchy since git show orders after find.
foldersTouched=`git show --pretty="format:" --name-only`
#For each folder, store only the path to the folder since only files are modified.
for f in $foldersTouched ; do
	dir=`dirname $f`;
	#If commit occurs in "config"-folder, treat it like it occured in the root-folder to pass the check against the folder-structure.
	base=`basename $dir`;
	if [ "$base" == "configs" ]; then
		dir=`dirname $dir`;
	fi  
	#since git show respects the hierarchy, check if already touched folder is in list is sufficient to reduce any duplicates
	if [[ "$images" != *"$dir"* ]]; then
		#Exclude some folders from the search like .git, _scripts..everything where commits do not affect images should be ignored.
		images="$images `find $dir -type d -print | grep -v -E ".git|_doc|_scripts|configs"`";
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
echo "Building the following images"
echo "${images}"
echo "Pushing to registry-t.sbb.ch"

#Getting the imagenames only for referring to dependant parents if necessary.
imagenames=`basename -a $images`
#Adapt the dockerfiles to point to registry-t and to point to adjacent parents included in this build, if necessary.
for path in $images do
	dockerfile=$path/Dockerfile
	#Always referring to prod-registry.
	sed -ri "s#FROM schweizerischebundesbahnen#FROM registry-i.sbb.ch#g" ${dockerfile}
	search=`grep "FROM registry-i.sbb.ch" ${dockerfile}`
	currentparent=`basename $( echo $search | cut -d " " -f2 )`
	#Iterate through all images to build to adapt parent-reference if necessary.
	#This means, the parent is build if the parent is also part of this build.
	for parentname in $imagenames do
		#If parent is always built, point to the image to be build in this job. Adapting dockerfile over here.
		if [ "$parentname" = "$currentparent" ]; then
			echo "found $parentname"
			echo "Dockerfile: ${dockerfile}"
			echo "Old from: ${search}"
			sed -ri "s#${search}#${search}:${tag}#g" ${dockerfile}
			sed -ri "s#FROM registry.sbb.ch#FROM registry-t.sbb.ch#g" ${dockerfile}
			search2=`grep "FROM registry-t.sbb.ch" ${dockerfile}`
			echo "New from: ${search2}:${tag}"
		fi
		#else, the referring parent is registry.sbb.ch
	done
	image=`basename $path`
	# build and push images
	echo "docker build --rm --no-cache -t schweizerischebundesbahnen/${image}:${tag} ./${path}"
	sudo docker build --rm --no-cache -t schweizerischebundesbahnen/${image}:${tag} ./${path}
	if [ $? -ne 0 ]; then
	echo "BUILD failed! Image=$IMAGE"
	exit -1
	fi
	# if everything is ok till now: push images to internal registry
	echo "docker tag "schweizerischebundesbahnen/${image}:${tag}" "registry-t.sbb.ch/${image}:${tag}""
	sudo docker tag "schweizerischebundesbahnen/${image}:${tag}" "regist
	ry-t.sbb.ch/${image}:${tag}"
	if [ $? -ne 0 ]; then
	echo "BUILD failed! Tagging image=$image failed!"
				exit -2
	fi

	echo "docker push registry-t.sbb.ch/${image}:${tag}"
	sudo docker push registry-t.sbb.ch/${image}:${tag}
	if [ $? -ne 0 ]; then
	echo "BUILD failed! Pushing image=$image failed!"
	exit -3
	fi

	# delete images from disk, if succesful. Exit otherwise
	if [ $error -eq 0 ]; then
		sudo docker rmi -f "registry-t.sbb.ch/${image}:${tag}"
		sudo docker rmi -f "schweizerischebundesbahnen/${image}:${tag}"
	else
		exit $error
	fi

done
exit $error
