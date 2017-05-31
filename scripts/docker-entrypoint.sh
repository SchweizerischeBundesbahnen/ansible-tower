#!/bin/bash
set -e # fail fast
set -x # echo everything
trap "kill -15 -1 && echo all proc killed" TERM KILL INT

#Check if Persisted Data exists, exiting if not
if [  ! -d "/tmp/persisted" ]; then
   echo "Mount for persisted-data /tmp/persisted not existing, skipping..."
   exit 101
fi
#Check if Log Data exists, exiting if not
if [  ! -d "/var/log" ] ; then
   echo "Mount for log /var/log not existing, please mount in container"
   exit 101
else
   cp -pRn /var/log.bak/. /var/log
   setfacl -Rm o:r-X,d:o:r-X /var/log
fi
#Fail Fast, Settings not existing, exiting because of missing clone
if [ ! -d "/tmp/etc/tower" ]; then
   echo "Settings /tmp/etc/tower not existing"
   echo "Taking standard permissions from the container"
else  
   cp -R --no-preserve=mode,ownership --backup /tmp/etc/tower/* /etc/tower
   chown -R awx:awx /etc/tower
fi
#Check if DB-Mount exists, exiting if not
if [  ! -d "/var/lib/postgresql/9.4" ]; then
   echo "DB-mount /var/lib/postgresql/9.4 not existing, please mount in container"
   echo "Exiting..."
   exit 101
fi
#Check if AWX-Data exists, exiting if not
if [  ! -d "/var/lib/awx-data" ]; then
   echo "AWX-Data Mount /var/lib/awx-data not existing, please mount in container"
   echo "Exiting..."
   exit 101
fi
#Check if Secret Data exists, exiting if not
if [  ! -d "/secret" ]; then
   echo "Mount for secret-data /secret not existing, skipping..."
   exit 101
fi

if [ "$1" = 'initialize' ]; then
    #Bootstrapping postgres from container
    cp -pR /var/lib/postgresql/9.4.bak/main /var/lib/postgresql/9.4/main
    #Ugly hack to ensure that key stored in ha.py is in sync to the one stored in the db.
    #Copying it to "/tmp/persisted"
    cp -p /etc/tower/conf.d/ha.py /tmp/persisted/ha.py
    #Bootstrapping AWX-Data from container
    mkdir /var/lib/awx-data
    cp -pR /var/lib/awx/job_status.bak /var/lib/awx-data/job_status
    cp -pR /var/lib/awx/projects.bak /var/lib/awx-data/projects
    #Fixing Websocketport: https://issues.sbb.ch/browse/CDP-64
    echo "{\"websocket_port\": 11230}" > /var/lib/awx/public/static/local_settings.json && cat /var/lib/awx/public/static/local_settings.json
    #Fixing SSL-Access: https://issues.sbb.ch/browse/CDP-68
    echo -e "[http]\n\tsslVerify = false"> /var/lib/awx/.gitconfig && cat /var/lib/awx/.gitconfig
    #Success Message
    echo -e "----------------------------------------"
    echo -e "Done Bootstrapping..."
    echo -e "----------------------------------------"
elif [ "$1" = 'start' ]; then
    if [ ! "$(ls -A /var/lib/postgresql/9.4)" ] || [ ! "$(ls -A /var/lib/awx-data)" ] || [ ! "$(ls -A /etc/tower)" ]; then
        echo "DB and/or Data and/or Settings not existing. Clone and/or bootstrap first."
        exit 102
    fi
    source /secret/*
    #ha.py need to be copied from host
    cp -pR --backup /tmp/persisted/ha.py /etc/tower/conf.d/ha.py
    #quickfix because permissions / users changes between 3.0.2 and 3.1.1
    chown -R postgres:postgres /var/lib/postgresql/9.4 /var/log/postgresql
     #getting links to the data
    ln -sf /var/lib/awx-data/projects /var/lib/awx/projects
    ln -sf /var/lib/awx-data/job_status /var/lib/awx/job_status
    #.tower_version: check and replace if not up to date
    compare=`diff /var/lib/awx/.tower_version /var/lib/awx.bak/.tower_version`
    if [ -n "$VAR" ]; then
        cd /opt/tower-setup \
        && ./setup.sh \
        && ansible-tower-service stop
    fi
	#Starting the tower
    ansible-tower-service start
    echo -e "----------------------------------------"
    echo -e "Tower started, Process idles......."
    echo -e "----------------------------------------"
    sleep inf & wait
else
    exec "$@"
fi
