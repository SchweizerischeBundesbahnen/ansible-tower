#!/bin/bash
# confluence    This shell script takes care of starting and stopping
#               the confluence container.
#
# chkconfig: - 85 15

opts=" -p 8040:8040 -p 9040:9040 -e JAVA_XMX=3048m -e JAVA_PERMSIZE=512m  -v /var/data/confluence:/var/data/confluence -v /var/data/confluence/log:/opt/confluence/logs -d"
containername=confluence
imagename=schweizerischebundesbahnen/confluence:5.4.4

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
