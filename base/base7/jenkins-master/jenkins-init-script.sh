#!/bin/bash
# confluence    This shell script takes care of starting and stopping
#               the confluence container.
#
# chkconfig: - 85 15

APP_URL=ci-t.sbb.ch
opts="-p 8050:8050 -p 9050:9050 -e APP_URL=${APP_URL} -v /var/data/jenkins-master:/var/data/jenkins-master -d"
containername=jenkins-master
imagename=schweizerischebundesbahnen/jenkins-master

function start_container() {
	docker start $containername
}

function init_container() {
	docker run $opts --name $containername $imagename 
}

function stop_container() {
	docker stop $containername 
}

function reinitialize_container() {
  docker rm $containername
  init_container
}

function update() {
  docker pull ${imagename}
  stop_container
  reinitialize_container
}

case "$1" in
  start)
    start_container
    ;;
  stop)
    stop_container
    ;;
  init)
    init_container
    ;;
  reinitialize)
    reinitialize_container
    ;;
  update)
   update 
   ;;
  status)
    docker ps --all
    ;;
  *)
    echo $"Usage: $0 {start|stop|status|init|reinitialize|update}"
    exit 2
esac
