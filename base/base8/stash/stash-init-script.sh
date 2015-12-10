#!/bin/bash
# stash        This shell script takes care of starting and stopping
#               the stash container.
#
# chkconfig: - 85 15
APP_URL=code-t.sbb.ch
opts=" -p 7999:7999 -p 8120:8120 -p 9120:9120 -p 10120:10120 -p 11120:11120 -e APP_URL=${APP_URL} -v /var/data/stash/log:/var/data/stash/log -v /var/data/stash/caches:/var/data/stash/caches -v /var/data/stash/logs:/opt/stash/logs -v /var/data/stash/shared/data:/var/data/stash/shared/data -v /var/data/stash/conf:/var/data/stash/conf -d"
containername=stash
imagename=schweizerischebundesbahnen/stash:latest

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
