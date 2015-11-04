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
        echo "Exporting global variables"
        # export CATALINA_OPTS="${CATALINA_OPTS} -XX:MaxPermSize=769M"
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
# Setting DB Properties
echo "Setting Sonar DB-Properties"
sed -ri "s#MYSQL_HOST#${MYSQL_HOST}#g" /opt/sonar/conf/sonar.properties
sed -ri "s#MYSQL_USER#${MYSQL_USER}#g" /opt/sonar/conf/sonar.properties
sed -ri "s#MYSQL_DBNAME#${MYSQL_DBNAME}#g" /opt/sonar/conf/sonar.properties
sed -ri "s#MYSQL_PASSWORD#${MYSQL_PASSWORD}#g" /opt/sonar/conf/sonar.properties
cat /opt/sonar/conf/sonar.properties

# modifications for some environments
echo "Application modifications for App URL ${APP_URL}"
case "${APP_URL}" in
	"codequality-t.sbb.ch")
		# disable some unlicensed plugins
		rm -f /opt/sonar/extensions/plugins/sonar-sqale-plugin*
		rm -f /opt/sonar/extensions/plugins/sonar-views-plugin*
		 # disable mailserver
                echo "0.0.0.0 smtp-app.sbb.ch" >> /etc/hosts

	;;
        "codequality-t.sbb.ch")
        	# disable mailserver
		echo "0.0.0.0 smtp-app.sbb.ch" >> /etc/hosts
	;;
esac


echo "Starting Application";
/opt/sonar/bin/linux-x86-64/sonar.sh console &
child=$!
wait "$child"
