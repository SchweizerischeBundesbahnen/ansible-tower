#!/bin/bash
# jira        This shell script takes care of starting and stopping
#               the jira container.
#
# chkconfig: - 85 15

opts="-p 8070:8070 -p 9070:9070 -p 10070:10070 -v /var/data/jira:/var/data/jira -d -m 10g -e domain=issues-i.sbb.ch"
containername=jira
imagename=jira

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
