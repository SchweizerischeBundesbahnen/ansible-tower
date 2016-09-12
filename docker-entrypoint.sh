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
    
    #Settings not existing, exiting because of missing clone
    if [ ! -d "/etc/tower" ]; then
        echo "Settings not existing"
        echo "Please clone a repository with a valid \"input\"-folder and related settings."
        exit 101
    fi
    
    #DB not existing, copying from container
    if [  "$(ls -A /var/lib/postgresql/9.4/main)" ]; then
        echo "DB not existing, bootstrapping from container"
        cp -R /var/lib/postgresql/9.4/main.bak/* /var/lib/postgresql/9.4/main/*
    fi
    
    #Data not existing, copying from container
    if [  "$(ls -A /var/lib/awx)" ]; then
        echo "AWX data not existing, bootstrapping from container"
        cp -R /var/lib/awx.bak/* /var/lib/awx/*

        #Fixing Websocketport: https://issues.sbb.ch/browse/CDP-64
        echo "{\"websocket_port\": 11230}" > /var/lib/awx/public/static/local_settings.json && cat /var/lib/awx/public/static/local_settings.json
        #Fixing SSL-Access: https://issues.sbb.ch/browse/CDP-68
        echo -e "[http]\n\tsslVerify = false"> /var/lib/awx/.gitconfig && cat /var/lib/awx/.gitconfig
    fi
    # create the logs directories if they do not yet exist
    mkdir -p /var/log/apache2
    chown -R www-data:www-data /var/log/apache2
    mkdir -p /var/log/tower
    chown -R awx:awx /var/log/tower
    #Setting permissions to data and settings
    chown -R awx:awx /var/lib/awx /etc/tower
    chown -R postgres:postgres /var/lib/postgresql/9.4/main
    
    #Starting the tower
    ansible-tower-service start
    sleep inf & wait
else
    exec "$@"
fi

