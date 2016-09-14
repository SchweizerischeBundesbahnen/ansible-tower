#!/bin/bash
if [ "! $(ls -A /backup/tower-backup-latest.tar.gz))" ] ; then
    echo "/backup/tower-backup-latest.tar.gz not existing, no backup available"
    exit 102
fi

if [ "$(ls -A /var/lib/postgresql/9.4/main)" ] || [ "$(ls -A /var/lib/awx)" ]; then
    echo "DB (/var/lib/postgresql/9.4/main) and/or Data (/var/lib/awx) existing. Remove on Host first and try again. Exiting..."
    exit 102
fi

#Starting Backup
/opt/tower-setup/setup.sh -r /backup/tower-backup-latest.tar.gz
