#!/bin/bash
ENV_SRV_URL=http://wzufiler.sbb.ch/
APP_NAME=jenkins
# Graceful shutfown
_term() {
  echo "Caught SIGTERM signal!"
  echo "Killing $child"
  kill -TERM "$child"
  wait "$child"
}

# Load global application env Parameters
function getGlobalEnvParams {
	export JENKINS_JAVA_OPTS="-Dfile.encoding=utf-8 -Dorg.apache.jasper.runtime.BodyContentImpl.LIMIT_BUFFER=false -Djava.net.preferIPv4Stack=true -Djava.awt.headless=true -Dcom.sun.management.jmxremote.port=10050 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dorg.eclipse.jetty.server.Request.maxFormKeys=10000 -Dorg.eclipse.jetty.server.Request.maxFormContentSize=500000 -DJENKINS_HOME=/var/data/jenkins-master"
	export JENKINS_ARGS="--ajp13Port=9050 --handlerCountMax=600 --httpPort=8050"
}

# Download env file
function getStageEnvParams {
	wget ${ENV_SRV_URL}/${APP_ID} -O /tmp/env_stage.sh
	source /tmp/env_stage.sh
}

trap _term SIGTERM

getGlobalEnvParams

getStageEnvParams

echo "Starting Application ${APP_NAME}";
echo "${JAVA_HOME}/bin/java ${JENKINS_JAVA_OPTS} -jar /opt/jenkins.war ${JENKINS_ARGS} -server &"
${JAVA_HOME}/bin/java ${JENKINS_JAVA_OPTS} -jar /opt/jenkins.war ${JENKINS_ARGS} -server &

child=$! 
wait "$child"
