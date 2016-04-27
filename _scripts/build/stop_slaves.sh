#!/bin/bash
#
# Nimmt den letzten container als referenz und löscht alle Container älter als diesen. Prüft ob der
# entsprechende Slave wird vor dem Löschen gepürft ob noch builds laufen.
# Iteriert solange bis alle container ersetzt wurden.
#
# ACHTUNG: Benötigt den create Jenkins slave Set job, sonst sind alle Slaves weg!
# 


# hole den letzten Container
LAST_CONTAINER=`docker ps -l -q`

# Zu stoppende Container
TO_STOPP_LIST=( $(docker ps --before=${LAST_CONTAINER} -f name=jenkins-slave -q ) ) 

# solange to_stopp nicht leer
while [ ${#TO_STOPP_LIST[@]} -gt 0 ]
do
  echo "TO_STOPP_LIST size is ${#TO_STOPP_LIST[@]} big"

  # für jeden to_stopp
  for to_stopp in ${TO_STOPP_LIST[@]}
  do
    echo "Processing ${to_stopp}"

    # get slave_name
    slave_name=`docker ps --format "{{.Names}}" --filter "id=${to_stopp}"` 
    echo "slave_name=${slave_name}"
	
    # get id
    slave_id=""
    if [[ $slave_name == *"android"* ]]
    then
      slave_id=`sudo docker ps --format "{{.Names}}" --filter "id=${to_stopp}" | awk -F'-' '{print $5}'`
    else
      slave_id=`sudo docker ps --format "{{.Names}}" --filter "id=${to_stopp}" | awk -F'-' '{print $4}'`
    fi
    echo "slave_id=${slave_id}"
	
    # check if running jobs
    echo "Checking for running Jobs for slave=${slave_name}, ${slave_id}"
    slave_idle=`curl -s --data-urlencode script@idle_slaves.groovy https://ci.sbb.ch/scriptText --user fsvctip:sommer11 | grep ${slave_id} | wc -l`
    if [ $slave_idle -eq 1 ]; 
    then
	echo "Slave is idle, stopping it"
  	sudo docker kill ${to_stopp}
        sudo docker rm ${to_stopp}
    fi
  done

  TO_STOPP_LIST=( $(docker ps --before=${LAST_CONTAINER} -f name=jenkins-slave -q ) )

  echo "------------------------Finished one iteration------------------------"
  sleep 5
done
