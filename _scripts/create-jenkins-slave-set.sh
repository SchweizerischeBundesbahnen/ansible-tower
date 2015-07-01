#!/bin/bash

master=$1
numcpus=`cat /proc/cpuinfo | grep processor | wc -l`

# how many slaves do we expect on hardware
declare -A vmcountHW
vmcountHW[was7]=2
vmcountHW[was85]=16
vmcountHW[wmb]=2
vmcountHW[nodejs]=2
vmcountHW[iib9]=4
vmcountHW[android]=4

# how many slaves do we expect on vm
declare -A vmcountVM
vmcountVM[was7]=1
vmcountVM[was85]=1
vmcountVM[wmb]=1
vmcountVM[nodejs]=1
vmcountVM[iib9]=1
vmcountVM[android]=1

# which image belongs to which label
declare -A labelMap
labelMap[was7]="jenkins-slave-was7"
labelMap[was85]="jenkins-slave-was85"
labelMap[wmb]="jenkins-slave-wmb"
labelMap[nodejs]="jenkins-slave-js"
labelMap[iib9]="jenkins-slave-iib9"
labelMap[android]="jenkins-slave-mobile-android"



# check argument
if [ ! -z $master ]
then
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
			while [ $count -lt ${vmcount[$label]} ]
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
