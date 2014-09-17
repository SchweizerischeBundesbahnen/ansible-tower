# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV labels "swarm js"

# Install js binaries for build
RUN yum update -q -y && yum install -q nodejs npm -y && yum clean all 

# Run jenkins
CMD /root/run.sh && su - jenkins -c "source ${jenkinshome}/env.sh && /opt/jdk17/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive"
