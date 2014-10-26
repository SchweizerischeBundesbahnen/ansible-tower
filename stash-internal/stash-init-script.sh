#!/bin/bash
# stash        This shell script takes care of starting and stopping
#               the stash container.
#
# chkconfig: - 85 15

opts="-p 7990:7990 -v /var/data/stash/log:/var/data/atlassian-base/log -v /var/data/stash/logs:/var/data/atlassian-base/logs -v /var/data/stash/data:/var/data/atlassian-base/data -d -m 10g -e DOMAIN=code-t.sbb.ch"
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
