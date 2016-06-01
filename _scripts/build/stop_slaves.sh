#!/bin/bash
#
# Nimmt den letzten container als referenz und löscht alle Container älter als diesen. Prüft ob der
# entsprechende Slave wird vor dem Löschen gepürft ob noch builds laufen.
# Iteriert solange bis alle container ersetzt wurden.
#
# ACHTUNG: Benötigt den create Jenkins slave Set job, sonst sind alle Slaves weg!
# 


# hole den letzten Container
LAST_CONTAINER=`sudo docker ps -l -f name=jenkins-slave -q`

# Zu stoppende Container
TO_STOPP_LIST=( $(sudo docker ps --before=${LAST_CONTAINER} -f name=jenkins-slave -q ) ) 

# arg1 slave_name, arg2 containerid
function getSlaveID() {
    if [[ $1 == *"android"* ]]
    then
      slave_id=`sudo docker ps --format "{{.Names}}" --filter "id=$2" | awk -F'-' '{print $5}'`
    else
      slave_id=`sudo docker ps --format "{{.Names}}" --filter "id=$2" | awk -F'-' '{print $4}'`
    fi
    echo "${slave_id}"
}

# arg1 slave_id
function isSlaveIdle() {
    slave_idle=`curl -s --data-urlencode script@idle_slaves.groovy https://ci.sbb.ch/scriptText --user fsvctip:sommer11 | grep $1 | wc -l`
    echo $slave_idle
}

# arg1 container id
function deleteContainer() {
  echo "Deleting container $1"
  sudo docker kill $1
  sudo docker rm $1
}

# solange to_stopp nicht leer
while [ ${#TO_STOPP_LIST[@]} -gt 0 ]
do
  echo "TO_STOPP_LIST size is ${#TO_STOPP_LIST[@]} big"

  # für jeden to_stopp
  for to_stopp in ${TO_STOPP_LIST[@]}
  do
    echo "Processing ${to_stopp}"

    # get slave_name
    slave_name=`sudo docker ps --format "{{.Names}}" --filter "id=${to_stopp}"` 
    echo "slave_name=${slave_name}"
	
    # get id
    slave_id=`getSlaveID ${slave_name} ${to_stopp} `
    echo "slave_id=${slave_id}"
	
    # check if running jobs
    echo "Checking for running Jobs for slave=${slave_name}, ${slave_id}"
    slave_idle=`isSlaveIdle ${slave_id}`
    if [ $slave_idle -eq 1 ]; 
    then
	echo "Slave is idle, stopping it"
  	deleteContainer ${to_stopp}
    fi
  done

  TO_STOPP_LIST=( $(sudo docker ps --before=${LAST_CONTAINER} -f name=jenkins-slave -q ) )

  echo "------------------------Finished one iteration------------------------"
  sleep 5
done

# kill the reference itself
slave_name=`sudo docker ps --format "{{.Names}}" --filter "id=${LAST_CONTAINER}"`
slave_id=`getSlaveID ${slave_name} ${LAST_CONTAINER} `
echo "slave_id=${slave_id}"

todo=1
while [ $todo -gt 0 ]
do
  echo "Processing ${LAST_CONTAINER}"
  slave_idle=`isSlaveIdle ${slave_id}`
  if [ $slave_idle -eq 1 ];
  then
    echo "Slave is idle, stopping it"
    deleteContainer ${LAST_CONTAINER} 
    todo=0
  fi

  sleep 5
done
