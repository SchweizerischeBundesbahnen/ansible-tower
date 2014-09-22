# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV labels "swarm nodejs"

# Install js binaries for build
RUN yum update -q -y && yum install -q nodejs npm -y && yum clean all -q 

# Install packages for build
RUN npm install bower grunt grunt-cli --silent

# Add node binaries to path
RUN echo 'export PATH=$PATH:/node_modules/.bin' >> ${jenkinshome}/env.sh

# Run jenkins
CMD ${jenkinshome}/run.sh && su - jenkins -c "source ${jenkinshome}/env.sh && /opt/jdk17/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive"
