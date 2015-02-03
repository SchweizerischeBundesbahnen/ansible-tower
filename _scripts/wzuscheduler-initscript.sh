#!/bin/bash
#
# chkconfig: 35 90 12
# description: WZUSCHEDULER Docker
# Author: u213900
# Get function from functions library
. /etc/init.d/functions
start() {
        echo "Starting WZUScheduler Docker"
        sh /opt/docker/scripts/create-wzuscheduler.sh
}
stop() {
        echo "Stopping and removing WZUScheduler Container"
        sh /opt/docker/scripts/delete-wzuscheduler.sh
}
status() {
        echo "Getting Docker status: "
        docker ps -a
}
forcestop() {
        echo "Deleting WZUScheduler Container (also the ones that are nor running)"
        sh /opt/docker/scripts/forcestop-wzuscheduler.sh
}
### main logic ###
case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        stop
        start
        ;;
  status)
        status
        ;;
  forcestop)
        forcestop
        ;;
  restart|reload|condrestart)
        stop
        start
        ;;
  *)
        echo $"Usage: $0 {start|stop|restart|status|forcestop}"
        exit 1
esac
exit 0
