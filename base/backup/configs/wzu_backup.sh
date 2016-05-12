#!/bin/bash

cd wzu-backup
git pull

CONFIG="conf/${NAME}.conf"
source ${CONFIG}

export MODE
export NAME
export SOURCE_STAGE
export DESTINATION_STAGE
export STAGE
export APPNAME
export BASE_DIR
export DB_RESTORE_DIR

if [ -z "${NAME}" ]; then
      echo "Error: NAME is not set, exiting."
      exit 1
fi
if [ -z "${MODE}" ]; then
      echo "Error: MODE is not set, exiting."
      exit 1
fi

if [ "${MODE}" == "BACKUP" ]; then
    if [[ -x "backup_scripts/${NAME}.sh" ]]; then
        if [ -z "${STAGE}" ]; then
              echo "Error: STAGE is not set, exiting."
              exit 1
        fi
        echo "Backup script found. Starting Backup."
        ./backup_scripts/${NAME}.sh
        exit $?
    else
        echo "File ${NAME}.sh not found or not executable."
    fi
elif [ "${MODE}" == "RESTORE" ]; then
    if [[ -x "restore_scripts/${NAME}.sh" ]]; then
        if [ -z "${SOURCE_STAGE}" ]; then
              echo "Error: SOURCE_STAGE is not set, exiting."
              exit 1
        fi
        if [ -z "${DESTINATION_STAGE}" ]; then
              echo "Error: DESTINATION_STAGE is not set, exiting."
              exit 1
        fi
        echo "Restore script found. Starting Restore."
        ./restore_scripts/${NAME}.sh
        exit $?
      else
            echo "File ${NAME}.sh not found or not executable."
      fi
else
      echo "Unknown MODE: ${MODE}"
fi