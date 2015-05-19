#!/bin/bash
# /start-slave.sh ${externalport} ${host} ${jenkinshome} ${appuser} ${executors} ${master} ${slavename} ${ciuser} ${cipassword} ${labels}
set -ex

# start the docker daemon
/usr/local/bin/wrapdocker &

# prepare environment
echo "export externalport=$1\nhost=$2" >> $3/env.sh 

# start slave
su - ${4} -c "source ${3}/env.sh && /opt/jdk/bin/java -jar ${3}/swarm-client.jar -executors ${5} -fsroot ${3} -master ${6} -name ${7} -username ${8} -password ${9} -labels ${10} -mode exclusive"

