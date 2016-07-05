# Jenkins slave build node configured with a WAS 8.5 environment for Maven release tasks.
FROM registry.sbb.ch/kd_wzu/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV labels "was85 java"
ENV was8version "8.5-OM08"

# Download and extract WAS 85 and create profile
RUN cd /opt \
        &&  wget -qO- ${filerurl}/was-${was8version}.tar.gz | tar xfz - \
        && ln -s /opt/was85 ${jenkinshome}/buildtools/was85 \
        && /bin/bash ${jenkinshome}/buildtools/was85/profiles/default/bin/versionInfo.sh \
		&& chown -R ${appuser}:${appuser} ${jenkinshome} /opt/was85*
		
# Link WAS JDK for Jenkins
RUN cd ${jenkinshome}/buildtools \
        && ln -s ${jenkinshome}/buildtools/was85/java_1.7_64 ibm-jdk-was85 \
		&& ${jenkinshome}/buildtools/ibm-jdk-was85/bin/java -version

# Link custom keystore
RUN  cd ${jenkinshome}/buildtools \
	&& rm ./ibm-jdk-was85/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./ibm-jdk-was85/jre/lib/security/cacerts \
	&& ls -l ./ibm-jdk-was85/jre/lib/security/cacerts

# Create environment file
RUN echo 'export WAS85RUNTIME=/var/data/jenkins/buildtools/was85' >> ${jenkinshome}/env.sh

# Modify IBM JDK security settings
COPY java.security /opt/was85/java_1.7_64/jre/lib/security/java.security

# Start Slave
CMD echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive -noRetryAfterConnected -retry 1 -disableClientsUniqueId"
