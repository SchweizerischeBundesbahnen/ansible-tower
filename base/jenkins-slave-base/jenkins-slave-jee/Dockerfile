# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV labels "jee"

# Download and extract WAS 70 and create profile
RUN cd /opt \
        &&  wget -qO- ${filerurl}/was70.tar.gz | tar xfz - \
        && ln -s /opt/was70 ${jenkinshome}/buildtools/was70 \
        && /bin/bash ${jenkinshome}/buildtools/was70/profiles/default/bin/versionInfo.sh \
        && chown -R ${appuser}:${appuser} ${jenkinshome} /opt/was70*

# Download and extract WAS 85 and create profile
RUN cd /opt \
        &&  wget -qO- ${filerurl}/was85.tar.gz | tar xfz - \
        && ln -s /opt/was85 ${jenkinshome}/buildtools/was85 \
        && /bin/bash ${jenkinshome}/buildtools/was85/profiles/default/bin/versionInfo.sh \
        && chown -R ${appuser}:${appuser} ${jenkinshome} /opt/was85*

# Create environment file
RUN echo 'export WAS7RUNTIME=/var/data/jenkins/buildtools/was70 WAS85RUNTIME=/var/data/jenkins/buildtools/was85' >> ${jenkinshome}/env.sh

# Start Slave
CMD echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive"
