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

# Get WAS 70 JDK
RUN wget --quiet ${filerurl}/was70-jdk.tar.gz -O /tmp/was70-jdk.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/was70-jdk.tar.gz && ln -s jdk-ibm-1.6* ibm-jdk-was70 && rm -f /tmp/was70-jdk.tar.gz

# Get WAS 85 JDK
RUN wget --quiet ${filerurl}/was85-jdk.tar.gz -O /tmp/was85-jdk.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/was85-jdk.tar.gz && ln -s jdk-ibm-1.7* ibm-jdk-was85 && rm -f /tmp/was85-jdk.tar.gz

# Legacy stuff
RUN cd ${jenkinshome} && ln -s jdk-ibm-1.7.0.5 jdk-ibm-1.7.0.2

# Run jenkins
CMD su - jenkins -c "${jenkinshome}/run.sh" && su - jenkins -c "source ${jenkinshome}/env.sh && /opt/jdk17/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive"
