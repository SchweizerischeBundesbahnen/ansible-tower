#!/bin/bash
# confluence    This shell script takes care of starting and stopping
#               the confluence container.
#
# chkconfig: - 85 15

opts=" -p 8040:8040 -p 9040:9040 -v /var/data/confluence:/var/data/confluence -d"
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
  status)
    docker ps --all
    ;;
  *)
    echo $"Usage: $0 {start|stop|status|init|reinitialize}"
    exit 2
esac
