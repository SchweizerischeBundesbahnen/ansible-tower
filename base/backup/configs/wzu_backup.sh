#!/bin/bash

cd wzu-backup
git pull

CONFIG="conf/${NAME}.conf"
source ${CONFIG}

export MODE
export NAME
export APPNAME

function databaseBackup {
  ./bin/dump.sh
  return $?
}

function databaseRestore {
  ./bin/dump.sh
  return $?
}

function duplicityBackup {
  ./bin/duplicity-backup.sh --backup --config ${CONFIG}
  return $?
}

function duplicityRestore {
  rm -rf /var/data/${APPNAME}/${NAME}/
  ./bin/duplicity-backup.sh --restore /var/data/${APPNAME}/${NAME} --config ${CONFIG}
  return $?
}

function migrate() {
  if [[ -x "migration/${NAME}.sh" ]]
  then
    echo "Migration script found. Starting migration."
    ./migration/${NAME}.sh \
    && mv /var/data/${APPNAME}/${NAME}/${APPNAME}/{.,}* /var/data/${APPNAME}/
    return $?
  else
    echo "File ${NAME}.sh not found or not executable."
    mv /var/data/${APPNAME}/${NAME}/${APPNAME}/{.,}* /var/data/${APPNAME}/
  fi
}

if [ -z "${NAME}" ]; then
  echo "Error: NAME is not set, exiting."
  exit 1
fi

if [ -z "${APPNAME}}" ]; then
  echo "Error: APPNAME is not set, exiting."
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