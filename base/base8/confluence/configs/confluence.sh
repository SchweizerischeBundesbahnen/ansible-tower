#!/bin/bash
ENV_SRV_URL="https://s3.eu-central-1.amazonaws.com/wzu-config/config/"
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
/opt/jira/bin/start-confluence.sh -fg &

child=$! 
wait "$child"
