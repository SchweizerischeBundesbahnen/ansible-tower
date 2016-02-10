#!/bin/bash

master=$1
numcpus=`cat /proc/cpuinfo | grep processor | wc -l`

# how many slaves do we expect on hardware
declare -A vmcountHW
vmcountHW[was7]=2
vmcountHW[was85]=16
vmcountHW[java]=6
vmcountHW[wmb]=2
vmcountHW[nodejs]=4
vmcountHW[android]=2
vmcountHW[sonargraph]=1

# how many slaves do we expect on vm
declare -A vmcountVM
vmcountVM[was7]=1
vmcountVM[was85]=1
vmcountVW[java]=1
vmcountVM[wmb]=1
vmcountVM[nodejs]=1
vmcountVM[android]=1
vmcountVM[sonargraph]=0

# which image belongs to which label
declare -A labelMap
labelMap[was7]="jenkins-slave-was7"
labelMap[was85]="jenkins-slave-was85"
labelMap[java]="jenkins-slave-base"
labelMap[wmb]="jenkins-slave-wmb"
labelMap[nodejs]="jenkins-slave-js"
labelMap[android]="jenkins-slave-mobile-android"
labelMap[sonargraph]="jenkins-slave-was85"


function checkOrStartVarnish() {
  local _varnishCount=`sudo docker ps | grep varnish | wc -l`
  if [ ${_varnishCount} -lt 1 ]; then
	echo "No varnish running! Starting varnish container"
	sudo docker run -p 80:80 --name repocache -v /etc/wzu/jenkins-varnish-config:/data/varnish --env 'VCL_CONFIG=/data/varnish/repo.sbb.ch.vcl' --env 'CACHE_SIZE=20g' registry.sbb.ch/kd_wzu/varnish
	if [ $? -ne 0 ]; then
		echo "Starting varnish container failed!"
		exit -1
	fi 
  fi
}



# check argument
if [ ! -z $master ]
then
	# start a varnish if none running
	checkOrStartVarnish
	
	# get current running count
        running=`curl -s --data-urlencode script@running_slaves.groovy $master/scriptText --user fsvctip:sommer11`
        declare -A runningCount
        for line in $running; do
        	#echo $line
                IFS='=' read -a array <<< "$line"
                runningCount[${array[0]}]=${array[1]}
	done

	# Hardware or virtualmachine?
	declare -A vmcount
	if [ $numcpus -gt 30 ]
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
		if [ ${runningCount[$label]} -lt  ${vmcount[$label]}  ]; then
			echo "missing some $label slaves"
			count=${runningCount[$label]}
			required=${vmcount[$label]}
			while [ $count -lt $required ]
			do
				echo "starting $label with ${labelMap[$label]}"
				./create-jenkins-slave.sh registry.sbb.ch ${labelMap[$label]} latest $master $label
				if [ $? -ne 0 ]; then
                                        echo "BUILD failed! Image=${labelMap[$label]}"
                                        exit -1
                                fi

				count=$(($count+1))
			done
		fi
	done

else
	echo "You need to set the master e.g http://ci-t.sbb.ch"
	exit 1
fi

exit 0
