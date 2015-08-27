#!/bin/bash
# jira        This shell script takes care of starting and stopping
#               the jira container.
#
# chkconfig: - 85 15

APP_URL=issues-t.sbb.ch
offset=20
apphome=/var/data/jira
opts="-p 80${offset}:80${offset} -p 90${offset}:90${offset} -p 100${offset}:100${offset} -v ${apphome}:/var/data/jira -e APP_URL=${APP_URL} -d"
containername=jira
imagename=registry.sbb.ch/jira
function start_container() {
	docker start $containername
}

function init_container() {
	mkdir -p ${apphome}/{logs,temp}
	chown -R 10${offset}:10${offset} ${apphome}
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
