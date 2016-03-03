#!/bin/bash
# This shell script takes care of starting and stopping
#
# chkconfig: - 85 15

repodir="/etc/wzu-docker"
projectname=`basename $0`
composefile="${repodir}/_scripts/${projectname}-config/docker-compose.yml"

source ${repodir}/_scripts/init-compose/compose-functions.sh
