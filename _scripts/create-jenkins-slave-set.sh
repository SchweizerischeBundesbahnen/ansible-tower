#!/bin/bash

master=$1
numcpus=`cat /proc/cpuinfo | grep processor | wc -l`

# how many slaves do we expect on hardware (PROD)
declare -A vmcountHW
vmcountHW["java"]=20
vmcountHW["android"]=2
vmcountHW["sonargraph"]=1

# how many slaves do we expect on vm (Testumgebung)
declare -A vmcountVM
vmcountVM["java"]=2
vmcountVM["android"]=0
vmcountVM["sonargraph"]=0

# which image belongs to which label
declare -A labelMap
labelMap["java"]="jenkins-slave-java"
labelMap["android"]="jenkins-slave-android"
labelMap["sonargraph"]="jenkins-slave-sonargraph"

declare -A runningCount
runningCount["java"]="0"
runningCount["android"]="0"
runningCount["sonargraph"]="0"

function checkOrStartVarnish() {
  VARNISHNAME=repocache
  sudo ./check-docker-container.sh ${VARNISHNAME}

  if [ $? -gt 2 ]; then
    sudo docker rm ${VARNISHNAME}
  fi

  if [ $? -gt 1 ]; then
    sudo docker run  \
       -p 80:80  \
       --restart=always  \
       -d  \
       --name ${VARNISHNAME}  \
       -v /etc/wzu/jenkins-varnish-config:/data/varnish  \
       --env 'VCL_CONFIG=/data/varnish/repo.sbb.ch.vcl'  \
       --env 'CACHE_SIZE=20g'  \
       registry.sbb.ch/kd_wzu/varnish
  fi

}

# check argument
if [ ! -z $master ]; then
  # start a varnish if none running
  checkOrStartVarnish

  # get current running count
  running=`curl -s --data-urlencode script@running_slaves.groovy $master/scriptText --user fsvctip:sommer11`
  for line in $running; do
    #echo $line
    IFS='=' read -a array <<< "$line"
    runningCount[${array[0]}]=${array[1]}
  done

  # Hardware or virtualmachine?
  declare -A vmcount
  if [ ${numcpus} -gt 30 ]
  then
    # copy array instead of assigning the values
    for key in "${!vmcountHW[@]}"
    do
      vmcount["$key"]="${vmcountHW["$key"]}"
    done
  else
    # copy array instead of assigning the values
    for key in "${!vmcountVM[@]}"
    do
      vmcount["$key"]="${vmcountVM["$key"]}"
    done
  fi

  # compare running with expected and start slaves if required
  for label in "${!vmcount[@]}"
  do
    if [ ${runningCount[$label]} -lt ${vmcount[$label]} ]; then
      echo "missing some $label slaves"
      count=${runningCount[$label]}
      required=${vmcount[$label]}
      while [ ${count} -lt $required ]
      do
        echo "starting $label with ${labelMap[$label]}"
        ./create-jenkins-slave.sh registry.sbb.ch/kd_wzu ${labelMap[$label]} latest ${master} "$label"
        if [ $? -ne 0 ]; then
          echo "BUILD failed! Image=${labelMap[$label]}"
          exit -1
        fi
        count=$(($count + 1))
      done
    fi
  done
else
  echo "You need to set the master e.g http://ci-t.sbb.ch"
  exit 1
fi
exit 0