# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/jenkins-slave-base 
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV labels "jee"

# Download and extract WAS 70 and create profile
RUN cd /opt &&  wget -qO- ${filerurl}/was70.tar.gz | tar xfz - && /bin/bash ${jenkinshome}/buildtools/was70/profiles/default/bin/versionInfo.sh && ln -s /opt/was70 ${jenkinshome}/buildtools/was70

# Download and extract WAS 85 and create profile 
RUN cd /opt &&  wget -qO- ${filerurl}/was85.tar.gz | tar xfz - && /bin/bash ${jenkinshome}/buildtools/was85/profiles/default/bin/versionInfo.sh && ln -s /opt/was70 ${jenkinshome}/buildtools/was85

# Get WAS 70 JDK
RUN wget --quiet ${filerurl}/was70-jdk.tar.gz -O /tmp/was70-jdk.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/was70-jdk.tar.gz && ln -s jdk-ibm-1.6* ibm-jdk-was70 && rm -f /tmp/was70-jdk.tar.gz

# Get WAS 85 JDK
RUN wget --quiet ${filerurl}/was85-jdk.tar.gz -O /tmp/was85-jdk.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/was85-jdk.tar.gz && ln -s jdk-ibm-1.7* ibm-jdk-was85 && rm -f /tmp/was85-jdk.tar.gz

# Legacy stuff
RUN cd ${jenkinshome}/buildtools && ln -s jdk-ibm-1.7.0.5 jdk-ibm-1.7.0.2 && ln -s was85 base_v85 && ln -s was70 base_v70

# Change timezone to Europe/Zurich
RUN ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

# Create environment file
RUN echo 'export WAS7RUNTIME=/var/data/jenkins/buildtools/was70 WAS85RUNTIME=/var/data/jenkins/buildtools/was85' >> ${jenkinshome}/env.sh

# Chown JENKINS_HOME to jenkins
RUN chown -R ${appuser}:${appuser} ${jenkinshome}

# Start Slave
CMD su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk17/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -username ${ciuser} -password ${cipassword} -labels ${labels}" 
