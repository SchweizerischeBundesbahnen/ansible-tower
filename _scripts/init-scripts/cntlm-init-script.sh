#!/bin/bash
# cntlm proxy   This shell script takes care of starting and stopping
#               the cntlm container.
#
# chkconfig: - 85 15
opts=" -p 3128:3128 -d "
containername=cntlm
imagename=dacr/cntlm

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
