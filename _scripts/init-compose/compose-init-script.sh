#!/bin/bash
# Just clone the git-repository to $repodir and symlink this script to /etc/init.d/projectname
# chkconfig: - 85 15

repodir="/etc/wzu-docker"
projectname=`basename $0`
composefile="${repodir}/_scripts/init-compose/${projectname}-config/docker-compose.yml"

source ${repodir}/_scripts/init-compose/compose-functions.sh
