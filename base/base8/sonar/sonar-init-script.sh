#!/bin/bash
# stash        This shell script takes care of starting and stopping
#               the stash container.
#
# chkconfig: - 85 15

APP_URL="codequality-t.sbb.ch"
opts=" --net=host -p 8110:8110 -p 9110:9110 -p 10110:10110 -v /var/data/sonar/logs/:/opt/sonar/logs/ -e APP_URL=${APP_URL} -e MYSQL_HOST=v01031.sbb.ch -e MYSQL_DBNAME=sonar -e MYSQL_USER=sonar -e MYSQL_PASSWORD=sonar -d"
containername=sonar
imagename=registry.sbb.ch/kd_wzu/sonar:latest

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
