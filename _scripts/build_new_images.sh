#!/bin/bash
commitid=`git log --format="%H" -1`
buildlist=`git show --pretty="format:" --name-only $commitid`

# build tasklist
declare -A todoList
for file in $buildlist 
do 
  image="$( cut -d '/' -f 1 <<< "$file" )";
  echo "tasklist: +$image"
  todoList[$image]=$image
done

cd ..
for task in "${todoList[@]}"
do
  echo $task
  sudo docker build --rm=true --tag="schweizerischebundesbahnen/$task" ./$task/
done
#echo "done"

