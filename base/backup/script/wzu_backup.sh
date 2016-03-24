#!/bin/bash

cd wzu-backup
git pull
source ${CONFIGFILE}

function dumpDatabase {
        ./dump.sh
}

function duplicityBackup {
        ./duplicity-backup.sh -b -c ${CONFIGFILE}
}


if [ "${TYPE}"  == "DBBACKUP" ] ; then
        dumpDatabase
        duplicityBackup
elif [ "${TYPE}" == "FILEBACKUP" ] ; then
        duplicityBackup
fi

