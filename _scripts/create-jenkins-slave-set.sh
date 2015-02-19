#!/bin/bash

master=$1
numcpus=`cat /proc/cpuinfo | grep processor | wc -l`
if [ ! -z $master ]
then
	if [ $numcpus -gt 30 ]
	then
		for i in {1..12}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-jee latest $master jee; done
		for i in {1..2}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-jee latest $master yves-migration; done
		for i in {1..2}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-js latest $master nodejs; done
		for i in {1..4}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-iib9 latest $master iib9; done
		for i in {1..4}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-mobile-android latest $master android; done
	else	
		for i in {1..1}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-jee latest $master jee; done
		for i in {1..1}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-jee latest $master yves-migration; done
		for i in {1..1}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-js latest $master nodejs; done
		for i in {1..1}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-iib9 latest $master iib9; done
		for i in {1..1}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-mobile-android latest $master android; done
	fi
else
	echo "You need to set the master e.g http://ci-t.sbb.ch"
	exit 1
fi
