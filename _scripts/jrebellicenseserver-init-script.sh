#!/bin/bash
# stash        This shell script takes care of starting and stopping
#               the stash container.
#
# chkconfig: - 85 15

opts=" -p 9000:8150 -v /var/data/jrebellicenseserver/logs:/var/data/jrebellicenseserver/logs -v /var/data/jrebellicenseserver/data:/var/data/jrebellicenseserver/data -d"
containername=jrebellicenseserver
imagename=registry.sbb.ch/kd_wzu/jrebellicenseserver:3.0.4

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
