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

if [ "${MODE}" == "BACKUP" ]; then
  if [ "${TYPE}" == "DB" ]; then
    databaseBackup
    duplicityBackup
  elif [ "${TYPE}" == "FILE" ]; then
    duplicityBackup
  fi
elif [ "${MODE}" == "RESTORE" ]; then
  if [ "${TYPE}" == "DB" ]; then
    duplicityRestore
    databaseRestore
  elif [ "${TYPE}" == "FILE" ]; then
    duplicityRestore
  fi
fi
