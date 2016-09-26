#!/bin/bash

#Starting Backup
/opt/tower-setup/setup.sh -b

#Copying Backup to /backup and removing original ones
find /opt/tower-setup -maxdepth 1 -mindepth 1 | grep tower-backup | grep -v tower-backup-latest.tar.gz | xargs -i mv {} /backup/tower-backup-latest.tar.gz

chown awx:awx /backup/tower-backup-latest.tar.gz

#Cleaning up stale link
rm /opt/tower-setup/tower-backup-latest.tar.gz