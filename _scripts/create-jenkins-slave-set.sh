#!/bin/bash

numcpus=`cat /proc/cpuinfo | grep processor | wc -l`

if [ $numcpus -gt 30 ]
	then
		for i in {1..12}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-jee latest https://ci.sbb.ch jee; done
		for i in {1..2}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-jee latest https://ci.sbb.ch yves-migration; done
		for i in {1..2}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-js latest https://ci.sbb.ch nodejs; done
		for i in {1..4}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-iib9 latest https://ci.sbb.ch iib9; done
		for i in {1..4}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-mobile-android latest https://ci.sbb.ch android; done
	else	
		for i in {1..1}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-jee latest https://ci.sbb.ch jee; done
		for i in {1..1}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-jee latest https://ci.sbb.ch yves-migration; done
		for i in {1..1}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-js latest https://ci.sbb.ch nodejs; done
		for i in {1..1}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-iib9 latest https://ci.sbb.ch iib9; done
		for i in {1..1}; do ./create-jenkins-slave.sh registry.sbb.ch jenkins-slave-mobile-android latest https://ci.sbb.ch android; done
fi
