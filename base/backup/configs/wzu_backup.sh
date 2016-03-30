#!/bin/bash

cd wzu-backup
git pull

CONFIG=${NAME}.conf
source ${CONFIG}

function databaseBackup {
  ./bin/dump.sh
}

function databaseRestore {
  export MODE=RESTORE
  ./bin/dump.sh
}

function duplicityBackup {
  ./bin/duplicity-backup.sh --backup --config ${CONFIG}
}

function duplicityRestore {
  ./bin/duplicity-backup.sh --restore /var/data/${NAME} --config ${CONFIG}
}

function migrate() {
  if [[ -x "migration/${NAME}.sh" ]]
  then
    echo "Migration script found. Starting migration."
    ./migration/${NAME}.sh
    return $?
  else
    echo "File ${NAME}.sh not found or not executable."
    mv /var/data/${NAME} /var/data/${APPNAME}
  fi
}

if [ -z "${NAME}" ]; then
  echo "Error: NAME is not set, exiting."
  exit 1
fi

if [ -z "${MODE}" ]; then
  echo "MODE is not set, defaulting to Backup."
  MODE="BACKUP"
fi

if [ "${MODE}" == "BACKUP" ]; then
  if [ "${TYPE}" == "DB" ]; then
    echo "Backing up Database."
    databaseBackup \
    && duplicityBackup
    exit $?
  elif [ "${TYPE}" == "FILE" ]; then
    echo "Backing up Filesystem."
    duplicityBackup
    exit $?
  else
    echo "Unknown TYPE: ${TYPE}"
  fi
elif [ "${MODE}" == "RESTORE" ]; then
  if [ "${TYPE}" == "DB" ]; then
    echo "Restoring Database."
    duplicityRestore \
    && databaseRestore \
    && migrate
    exit $?
  elif [ "${TYPE}" == "FILE" ]; then
    echo "Restoring Filesystem."
    duplicityRestore \
    && migrate
    exit $?
  else
    echo "Unknown TYPE: ${TYPE}"
  fi
else
  echo "Unknown MODE: ${MODE}"
fi