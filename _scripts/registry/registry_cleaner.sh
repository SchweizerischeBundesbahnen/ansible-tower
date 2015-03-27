#!/bin/bash 

readonly base_dir=/var/data/docker/storage
readonly repository_dir=$base_dir/repositories
readonly image_dir=$base_dir/images

TMPDIR="/tmp"
NEWLINE=$'\n'

# check if we run on a registry server
if [ ! -d "$repository_dir" ]; then
	echo "please run this tool on a registry server!"
	exit -1
fi

# get active branches in git
cd $TMPDIR
git clone https://code.sbb.ch/scm/kd_wzu/wzu-docker.git
cd wzu-docker
branch_list=`git branch -a | grep remotes | grep -v develop | grep -v master`
#cd ..
#rm -rf wzu-docker

tag_list=""
for branch in $branch_list; do
	tag=`basename $branch`
	tag_list="${tag_list}tag_${tag}${NEWLINE}"
done

echo "Branches in git repo"
echo $tag_list

# get tags in registry
used_tags=""
for library in $repository_dir/*; do
    for repo in $library/*; do
        for tag in $repo/tag_*; do
	    used_tags="${used_tags}${NEWLINE}$(basename $tag)"
        done
    done
done

echo "------------------"
echo "$used_tags"


echo "------------------"
echo "Tags in registry"
#clean_tags=`echo $used_tags|tr " " "\n"|grep -v *|grep -v latest|sort|uniq|tr "\n" " "` 
#clean_tags=`echo $used_tags|tr " " "\n"|grep -v *`
clean_tags=`echo $used_tags|tr " " "\n"|grep -v latest|sort|uniq|tr "\n" " "`

echo $clean_tags

echo "------------------"
# iterate trough lists
for tag in $clean_tags; do
	# check if tag exists as branch, if not so, delete tag
	exist=0;
	for branch in $tag_list; do
		if [ "$tag" == "$branch" ] || [ "$tag" == "tag_*" ]; then
			exist=1
		fi
	done
	if [ $exist -eq 0 ]; then
		echo "going to delete ${tag:4}"
		
		./_scripts/registry/remove-tag.sh ${tag:4} $1	
	fi
done

# cleanup
cd ..
rm -rf wzu-docker


exit 0
