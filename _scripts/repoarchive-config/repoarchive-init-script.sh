#!/bin/bash
# This shell script takes care of starting and stopping
#
# chkconfig: - 85 15

composefile="/etc/wzu-docker/_scripts/repoarchive-config/docker-compose.yml"
projectname="repoarchive"

function start_container() {
    docker-compose -f $composefile -p $projectname start
}

function init_container() {
    docker-compose -f $composefile -p $projectname create
}

function stop_container() {
	docker-compose -f $composefile -p $projectname stop
}

function delete_container() {
	docker-compose -f $composefile -p $projectname rm
}

function pull_container() {
    docker-compose -f $composefile -p $projectname pull
}

function status() {
  docker-compose -p $projectname -f $composefile ps
}

function logs() {
  docker-compose -p $projectname -f $composefile logs
}

function reinitialize_container() {
  stop_container
  delete_container
  init_container
  start_container
}

function update() {
  pull_container
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
  reinit)
    reinitialize_container
    ;;
  update)
   update 
   ;;
  status)
    status
    ;;
  logs)
    logs
    ;;
  *)
    echo $"Usage: $0 {start|stop|status|init|reinit|update|logs}"
    exit 2
esac
