#!/bin/bash
# confluence    This shell script takes care of starting and stopping
#               the confluence container.
#
# chkconfig: - 85 15
JENKINS_JAVA_OPTS="-XX:MaxPermSize=256m -Xms1024m -Xmx1024m -Xss1m -Dfile.encoding=utf-8 -Dorg.apache.jasper.runtime.BodyContentImpl.LIMIT_BUFFER=false -Djava.net.preferIPv4Stack=true -Djava.awt.headless=true -Dcom.sun.management.jmxremote.port=10050 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dorg.eclipse.jetty.server.Request.maxFormKeys=10000 -Dorg.eclipse.jetty.server.Request.maxFormContentSize=500000 -DJENKINS_HOME=/var/data/jenkins-master"
JENKINS_ARGS="--ajp13Port=9050 --handlerCountMax=600 --httpPort=8050"
opts='-p 8050:8050 -p 9050:9050 -e JENKINS_JAVA_OPTS="$JENKINS_JAVA_OPTS" -e JENKINS_ARGS="$JENKINS_ARGS" -v /var/data/jenkins-master:/var/data/jenkins-master -d'
containername=jenkins-master
imagename=jenkins-master

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
