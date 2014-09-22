# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/jenkins-slave-base 
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

#Environment variables
ENV mvn30version 3.0.5
ENV mvn31version 3.1.1
ENV mvn32version 3.2.3
ENV antversion 1.9.4
ENV swarmversion 1.16
ENV appuser jenkins
ENV portoffset 90
ENV datadir /var/data 
ENV jenkinshome ${datadir}/jenkins
ENV master http://ci-t.sbb.ch
ENV ciuser overridethis 
ENV svnuser fsbuild 
ENV cipassword overridethis 
ENV svnpassword fsbuild2011 
ENV executors 1
ENV filerurl http://wzufiler.sbb.ch
ENV settingsxmlurl https://svn.sbb.ch/svn/mwe/wzu/ci-admin-files/settings.xml 
ENV labels "swarm jee"

# Download and extract WAS 70 and create profile
RUN wget --quiet ${filerurl}/was70.tar.gz -O /tmp/was70.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/was70.tar.gz && rm -f /tmp/was70.tar.gz && ${jenkinshome}/buildtools/was70/bin/manageprofiles.sh -create -profileName default -nodeName default -hostName localhost && /bin/bash ${jenkinshome}/buildtools/was70/profiles/default/bin/versionInfo.sh

# Download and extract WAS 85 and create profile 
RUN wget --quiet ${filerurl}/was85.tar.gz -O /tmp/was85.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/was85.tar.gz && rm -f /tmp/was85.tar.gz && /bin/bash ${jenkinshome}/buildtools/was85/profiles/default/bin/versionInfo.sh

# Get WAS 70 JDK
RUN wget --quiet ${filerurl}/was70-jdk.tar.gz -O /tmp/was70-jdk.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/was70-jdk.tar.gz && ln -s jdk-ibm-1.6* ibm-jdk-was70 && rm -f /tmp/was70-jdk.tar.gz

# Get WAS 85 JDK
RUN wget --quiet ${filerurl}/was85-jdk.tar.gz -O /tmp/was85-jdk.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/was85-jdk.tar.gz && ln -s jdk-ibm-1.7* ibm-jdk-was85 && rm -f /tmp/was85-jdk.tar.gz

# Legacy stuff
RUN cd ${jenkinshome} && ln -s jdk-ibm-1.7.0.5 jdk-ibm-1.7.0.2 && ln -s was85 base_v85 && ln -s was70 base_v70

# Change timezone to Europe/Zurich
RUN ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

# Create environment file
RUN echo 'export WAS7RUNTIME=/var/data/jenkins/buildtools/was70 WAS85RUNTIME=/var/data/jenkins/buildtools/was85' >> ${jenkinshome}/env.sh

# Chown JENKINS_HOME to jenkins
RUN chown -R jenkins:jenkins ${jenkinshome}

# Start Slave
CMD ${jenkinshome}/run.sh && su - jenkins -c "source ${jenkinshome}/env.sh && /opt/jdk17/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -username ${ciuser} -password ${cipassword} -labels ${labels}" 
