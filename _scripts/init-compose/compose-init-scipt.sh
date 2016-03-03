#!/bin/bash
# This shell script takes care of starting and stopping
#
# chkconfig: - 85 15

projectname="basename $0"
composefile="/etc/wzu-docker/_scripts/${projectname}-config/docker-compose.yml"

source compose-functions.sh
