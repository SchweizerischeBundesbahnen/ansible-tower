#!/usr/bin/env bash
# This shell script is a functions repository for init scripts
# @author u210691 <igor.masen@sbb.ch>
# @version 1.0

PATH=$PATH:/usr/local/bin

function start_container() {
    docker-compose -f $composefile -p $projectname start
}

function init_container() {
    docker-compose -f $composefile -p $projectname up -d
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