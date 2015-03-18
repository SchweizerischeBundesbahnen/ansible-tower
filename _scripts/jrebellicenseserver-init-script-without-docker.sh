#!/bin/bash
export appversion=3.0.4
export appuser=jrebellicense
export idoffset=150
export datadir=/var/data
export apphome=/var/data/jrebellicenseserver
export PATH=/usr/local/bin:/sbin:/usr/sbin:/usr/bin:/bin

function start_container() {
	/opt/jdk/bin/java -Dhttp.port=9000 -Drebel.ls.logfile=${apphome}/logs/license-server.log -Drebel.ls.dataDir=${apphome}/data -jar /opt/license-server/lib/license-server.jar >> ${apphome}/logs/license-server.out 2>&1
}

function stop_container() {
	/opt/license-server/bin/license-server.sh stop
}

function status() {
  ps aux | grep /opt/license-server/bin
}

case "$1" in
  start)
    start_container
    ;;
  stop)
    stop_container
    ;;
  status)
    status
    ;;
  *)
    echo $"Usage: $0 {start|stop|status}"
    exit 2
esac
