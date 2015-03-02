FROM schweizerischebundesbahnen/jenkins-slave-jee
MAINTAINER Christoph Glanzmann <christoph.glanzmann@sbb.ch>

ENV labels "jee-release"

COPY jre16-java.security /opt/was70/java/jre/lib/security/java.security
COPY jre17-java.security /opt/was85/java_1.7_64/jre/lib/security/java.security

# Start Slave
CMD echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive"
