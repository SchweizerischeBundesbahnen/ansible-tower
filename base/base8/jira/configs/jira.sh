#!/bin/bash
ENV_SRV_URL=http://wzufiler.sbb.ch/
APP_NAME=issues
# Graceful shutfown
_term() {
  echo "Caught SIGTERM signal!"
  echo "Killing $child"
  kill -TERM "$child"
  wait "$child"
}

# Load global application env Parameters
function getGlobalEnvParams {
	export CATALINA_OPTS="${CATALINA_OPTS} -XX:MaxPermSize=769M"
}

# Download env file
function getStageEnvParams {
	wget ${ENV_SRV_URL}/${APP_NAME}_${STAGE} -O /tmp/env_stage.sh
	source /tmp/env_stage.sh
}

trap _term SIGTERM

getGlobalEnvParams

getStageEnvParams

echo "Starting Application ${APP_NAME}";
/opt/jira/bin/start-jira.sh -fg &

child=$! 
wait "$child"
