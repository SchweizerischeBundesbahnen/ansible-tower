#!/bin/bash
APACHE_CONF=/etc/apache2/conf-enabled/awx-httpd-443.conf
# bash setup
set -e # fail fast
set -x # echo everything
trap "kill -15 -1 && echo all proc killed" TERM KILL INT

# remove stale pid file when restarting the same container
rm -f /run/apache2/apache2.pid

if [ "$1" = 'ansible-tower' ]; then
    #Correcting Apache Config
    if [[ ${SERVER_NAME} ]]; then
        echo "add ServerName to $SERVER_NAME"
        head -n 1 ${APACHE_CONF} | grep -q "^ServerName" \
        && sed -i -e "s/^ServerName.*/ServerName $SERVER_NAME/" ${APACHE_CONF} \
        || sed -i -e "1s/^/ServerName $SERVER_NAME\n/" ${APACHE_CONF}
    fi
    
    mkdir ${DATA}
    
    #Live data not existing, bootstrapping instance
    if [[ ! -e ${SETTINGS} ]]; then
        echo "Settings not existing"
        echo "Please clone a repository with a valid \"input\"-folder and related settings."
        exit 101
        
        
        #Fixing Websocketport: https://issues.sbb.ch/browse/CDP-64
        echo "{\"websocket_port\": 11230}" > ${DATA}/awx/public/static/local_settings.json
        #Fixing SSL-Access: https://issues.sbb.ch/browse/CDP-68
        echo -e "[http]\n\tsslVerify = false"> ${DATA}/awx/.gitconfig && cat ${DATA}/awx/.gitconfig
        
        
        
        
        
        
        
        # create the logs directories if they do not yet exist
        mkdir -p ${LOGS}/apache2
        chown -R www-data:www-data ${LOGS}/apache2
        mkdir -p ${LOGS}/tower
        chown -R awx:awx ${LOGS}/tower
        
    fi

    chown -R awx:awx ${DATA} ${SETTINGS}
    chown -R postgres:postgres ${DATA}/postgres
    
    #Starting the tower
    ansible-tower-service start
    sleep inf & wait
else
    exec "$@"
fi

