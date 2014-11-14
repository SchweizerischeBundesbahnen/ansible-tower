#!/bin/bash
# stash        This shell script takes care of starting and stopping
#               the stash container.
#
# chkconfig: - 85 15

opts=" --privileged=true -p 8090:8090 -v /var/data/stash/log:/var/data/atlassian-base/log -v /var/data/stash/logs:/var/data/atlassian-base/logs -v /var/data/stash/shared/data:/var/data/atlassian-base/shared/data -d -m 10g"
containername=schweizerischebundesbahnen/stash-internal:3.4.1
imagename=schweizerischebundesbahnen/stash-internal:3.4.1

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
