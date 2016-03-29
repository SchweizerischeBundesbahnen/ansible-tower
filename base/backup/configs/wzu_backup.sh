#!/bin/bash

cd wzu-backup
git pull
source ${CONFIGFILE}

function databaseBackup {
  ./dump.sh
}

function databaseRestore {
  echo "Not implemented yet"
}

function duplicityBackup {
  ./duplicity-backup.sh --backup --config ${CONFIGFILE}
}

function duplicityRestore {
  ./duplicity-backup.sh --restore /var/data/${NAME}_migrate --config ${CONFIGFILE}
}

if [ -z "${TYPE}" ]; then
  echo "MODE is not set, defaulting to Backup."
  MODE="BACKUP"
fi

if [ "${MODE}" == "BACKUP" ]; then
  if [ "${TYPE}" == "DB" ]; then
    echo "Backing up Database."
    databaseBackup
    duplicityBackup
  elif [ "${TYPE}" == "FILE" ]; then
    echo "Backing up Filesystem."
    duplicityBackup
  else
    echo "Unknown TYPE detected"
  fi
elif [ "${MODE}" == "RESTORE" ]; then
  if [ "${TYPE}" == "DB" ]; then
    echo "Restoring Database."
    duplicityRestore
    databaseRestore
  elif [ "${TYPE}" == "FILE" ]; then
    echo "Restoring Filesystem."
    duplicityRestore
  else
    echo "Unknown TYPE detected"
  fi
else
  echo "Unknown MODE detected"
fi