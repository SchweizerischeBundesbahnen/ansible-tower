#!/bin/bash

readonly base_dir=/var/data/docker/storage
readonly repository_dir=$base_dir/repositories
readonly image_dir=$base_dir/images

TMPDIR="tmp-cleaner"
NEWLINE=$'\n'

# check if we run on a registry server
if [ ! -d "$repository_dir" ]; then
        echo "please run this tool on a registry server!"
        exit -1
fi

# check if we have the registry argument
if [ $# -ne 1 ]; then
        echo "usage: registry_cleaner.sh registry-t.sbb.ch"
        exit -1
fi

REGISTRY_TO_CLEAN=$1

#
# get active branches in git
if [ "${REGISTRY_TO_CLEAN}" == "registry-t.sbb.ch" ]; then
  mkdir $TMPDIR
  cd $TMPDIR
  git clone https://code.sbb.ch/scm/kd_wzu/wzu-docker.git
  cd wzu-docker
  branch_list=`git branch -a | grep remotes | grep -v develop | grep -v master`

  tag_list=""
  for branch in $branch_list; do
        tag=`basename $branch`
        tag_list="${tag_list}tag_${tag}${NEWLINE}"
  done

  echo "Branches in git repo"
  echo $tag_list

  cd ..
  cd ..
  rm -rf $TMPDIR
fi

#
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
clean_tags=`echo $used_tags|tr " " "\n"|grep -v latest| grep -i WZU|sort -r|uniq|tr "\n" " "`

echo $clean_tags

echo "------------------"
# iterate trough lists
buildCount=0
for tag in $clean_tags; do
        if [ "${REGISTRY_TO_CLEAN}" == "registry-t.sbb.ch" ]; then
                # check if tag exists as branch, if not so, delete tag
                exist=0;
                for branch in $tag_list; do
                        if [ "$tag" == "$branch" ] || [ "$tag" == "tag_*" ]; then
                                exist=1
                        fi
                done
                if [ $exist -eq 0 ]; then
                        echo "going to delete ${tag:4}"
                        ./remove-tag.sh ${tag:4} $1
                fi
        else
                let buildCount=buildCount+1
                if [ $buildCount -gt 10 ]; then
                        echo "going to delete ${tag:4}"
                        ./remove-tag.sh ${tag:4} $1
                fi
        fi
done

exit 0

