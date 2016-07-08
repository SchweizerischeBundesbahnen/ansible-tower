#!/bin/bash
ENV_SRV_URL="https://s3.eu-central-1.amazonaws.com/wzu-config/config"
CNF_NAME="/tmp/env_stage.sh"
# Graceful shutfown
_term() {
  echo "Caught SIGTERM signal!"
  echo "Killing $child"
  kill -TERM "$child"
  wait "$child"
}

# Load global application env Parameters
function getGlobalEnvParams {
	export JENKINS_JAVA_OPTS="-Dhudson.model.ParametersAction.keepUndefinedParameters=true -Dfile.encoding=utf-8 -Dorg.apache.jasper.runtime.BodyContentImpl.LIMIT_BUFFER=false -Djava.net.preferIPv4Stack=true -Djava.awt.headless=true -Dcom.sun.management.jmxremote.port=10050 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dorg.eclipse.jetty.server.Request.maxFormKeys=10000 -Dorg.eclipse.jetty.server.Request.maxFormContentSize=500000 -Dhudson.model.DirectoryBrowserSupport.CSP= -DJENKINS_HOME=/var/data/jenkins-master"
	export JENKINS_ARGS="--ajp13Port=9050 --handlerCountMax=1000 --httpPort=8050"
}
# Download env file
function getStageEnvParams {
        echo "Getting app_url variables from ${ENV_SRV_URL}/${APP_URL}"
        wget ${ENV_SRV_URL}/${APP_URL}.config -O ${CNF_NAME}
        # If file does not exist,quit
        if [ $? -ne 0 ]; then
                echo "Configfile for APP_URL ${APP_URL} not found but APP_URL was set! exiting"
                exit 1
        fi
        source ${CNF_NAME}
}

trap _term SIGTERM

getGlobalEnvParams
# If app_url is set, try to get it
if [ -n "${APP_URL}" ]; then
        getStageEnvParams
fi

echo "Starting Application";
echo "${JAVA_HOME}/bin/java ${JENKINS_JAVA_OPTS} -jar /opt/jenkins.war ${JENKINS_ARGS} -server &"
${JAVA_HOME}/bin/java ${JENKINS_JAVA_OPTS} -jar /opt/jenkins.war ${JENKINS_ARGS} -server &

child=$! 
wait "$child"
