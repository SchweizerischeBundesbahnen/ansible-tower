#!/bin/bash
# code        This shell script takes care of starting and stopping
#               the code container.
#
# chkconfig: - 85 15
APP_URL=code-t.sbb.ch
opts=" -p 7999:7999 -p 8120:8120 -p 9120:9120 -p 10120:10120 -p 11120:11120 -e APP_URL=${APP_URL} -v /var/data/code-app/log:/var/data/code/log -v /var/data/code-app/caches:/var/data/code/caches -v /var/data/code-app/logs:/opt/code/logs -v /var/data/code-data/shared/data:/var/data/code/shared/data -v /var/data/code-app/conf:/var/data/code/conf -d"
containername=code
imagename=registry.sbb.ch/kd_wzu/code:latest

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
    echo $"Usage: $0 {start|stop|status|init|reinitialize}"
    exit 2
esac
