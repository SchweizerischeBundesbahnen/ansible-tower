#!/bin/bash
# models        This shell script takes care of starting and stopping
#               the models container.
#
# chkconfig: - 85 15
opts=" -p 80:8170 -d -v /var/www/models"
containername=models
imagename=registry.sbb.ch/kd_wzu/models

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
