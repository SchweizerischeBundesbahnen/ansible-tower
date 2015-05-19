#!/bin/bash

IFS=$'\n'

lines="`sudo btrfs fi show | grep devid`"

function optimize() {
	sudo btrfs fi balance start -dusage=5 $1
}

function analyse() {
#	echo $1

	IFS=' '
	line=($device)
	
	# get device and values
	path=${line[7]}
	used=${line[5]:0: -6}
        avail=${line[3]:0: -6}

	# calculate du
	let "du = 100 * $used / $avail"
	
}

for device in $lines; do
        
	analyse $device
	
        echo $du

	# check value and optimize
	if [ $du -gt 80 ]; then
             optimize /var/lib/docker/
        fi
done
