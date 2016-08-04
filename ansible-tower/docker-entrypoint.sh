#!/bin/bash
APACHE_CONF=/etc/apache2/conf-enabled/awx-httpd-443.conf
set +e
trap "kill -15 -1 && echo all proc killed" TERM KILL INT

function setupSettings {
    sharefile=$1
    dockerfile=$2
    
    
    if [[ ! -e $sharefile ]]; then
        echo "$sharefile not exiting, copying version of container to mount"
        cp $dockerfile $sharefile
    fi
    if [[ -e $dockerfile ]]; then
        mv $dockerfile $dockerfile.bak
        ln -s $sharefile $dockerfile
        chown awx:awx $dockerfile $sharefile
    fi
}

if [ "$1" = 'ansible-tower' ]; then
    #Correcting Apache Config
    if [[ ${SERVER_NAME} ]]; then
        echo "add ServerName to $SERVER_NAME"
        head -n 1 ${APACHE_CONF} | grep -q "^ServerName" \
        && sed -i -e "s/^ServerName.*/ServerName $SERVER_NAME/" ${APACHE_CONF} \
        || sed -i -e "1s/^/ServerName $SERVER_NAME\n/" ${APACHE_CONF}
    fi
    
    #Live data not existing, bootstrapping instance
    if [[ ! -e ${DATA} ]]; then
        mkdir ${DATA}
        cp -R /var/lib/postgresql/9.4/main.bak ${DATA}/postgres
        cp -R /var/lib/awx.bak ${DATA}/awx
        #Fixing Websocketport: https://issues.sbb.ch/browse/CDP-64
        echo "{\"websocket_port\": 11230}" > ${DATA}/awx/public/static/local_settings.json
        #Fixing SSL-Access: https://issues.sbb.ch/browse/CDP-68
        echo -e "[http]\n\tsslVerify = false"> ${DATA}/awx/.gitconfig && ${DATA}/awx/.gitconfig
    fi
    chown -R awx:awx ${DATA}/awx ${SETTINGS} ${LOGS}
    chown -R postgres:104 ${DATA}/postgres
    
    
    #Starting the tower
    ansible-tower-service start
    #sleep 10
    #watch "netstat -an | grep -E '443.*LISTEN'"
    sleep inf & wait
else
    exec "$@"
fi

