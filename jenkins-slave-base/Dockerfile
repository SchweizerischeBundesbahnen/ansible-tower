# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/jenkins-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

#Environment variables
ENV appuser jenkins
ENV jenkinshome ${datadir}/jenkins
ENV master http://ci-t.sbb.ch
ENV labels swarm


# Download the swarm client
RUN wget --quiet "http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/${swarmversion}/swarm-client-${swarmversion}-jar-with-dependencies.jar" -O ${jenkinshome}/swarm-client.jar

# Chown JENKINS_HOME to jenkins
RUN chown -R ${appuser}:${appuser} ${jenkinshome}

# Start Slave
CMD su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk17/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -username ${ciuser} -password ${cipassword} -labels ${labels}" 
