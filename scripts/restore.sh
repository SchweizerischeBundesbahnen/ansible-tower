#!/bin/bash
if [ ! -f /backup/tower-backup-latest.tar.gz ] ; then
    echo "/backup/tower-backup-latest.tar.gz not existing, no backup available"
    exit 102
fi

if [ "$(ls -A /var/lib/postgresql/9.4/main)" ] || [ "$(ls -A /var/lib/awx-data)" ]; then
    echo "DB (/var/lib/postgresql/9.4/main) and/or Data (/var/lib/awx-data) existing. Remove on Host first and try again. Exiting..."
    exit 102
fi

#Copying backup to correct location
cp /backup/tower-backup-latest.tar.gz /opt/tower-setup/tower-backup-latest.tar.gz

#Bootstrapping first and starting and waiting
./docker-entrypoint.sh initialize
ansible-tower-service start
sleep 10
#restoring
/opt/tower-setup/setup.sh -r /opt/tower-setup/tower-backup-latest.tar.gz
#storing the restored ha.py to persistent volume
cp -p /etc/tower/conf.d/ha.py /tmp/persisted/ha.py
#settle everything and stop
sleep 10
ansible-tower-service stop
