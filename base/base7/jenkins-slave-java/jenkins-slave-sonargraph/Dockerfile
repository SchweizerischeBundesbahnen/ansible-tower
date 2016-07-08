# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM registry.sbb.ch/kd_wzu/jenkins-slave-java
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV labels "sonargraph java"

CMD echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive -noRetryAfterConnected -retry 1 -disableClientsUniqueId"
