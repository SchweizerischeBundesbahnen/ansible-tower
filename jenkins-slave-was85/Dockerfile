# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV labels "was85"

# Download and extract WAS 85 and create profile
RUN cd /opt \
        &&  wget -qO- ${filerurl}/was85.tar.gz | tar xfz - \
        && ln -s /opt/was85 ${jenkinshome}/buildtools/was85 \
        && /bin/bash ${jenkinshome}/buildtools/was85/profiles/default/bin/versionInfo.sh \
        && chown -R ${appuser}:${appuser} ${jenkinshome} /opt/was85*

# Link WAS85 JDK to the right place
RUN cd ${jenkinshome}/buildtools && ln -s /opt/was85/java_1.7_64 ibm-jdk-was85 && ${jenkinshome}/buildtools/ibm-jdk-was85/bin/java -version

# Legacy stuff
RUN cd ${jenkinshome}/buildtools && ln -s ibm-jdk-was85 jdk-ibm-1.7.0.2 && ln -s was85 base_v85

# Create environment file
RUN echo 'export WAS85RUNTIME=/var/data/jenkins/buildtools/was85' >> ${jenkinshome}/env.sh

# Start Slave
CMD echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive"
