# Jenkins slave build node configured with a WAS 7 environment for Maven release tasks.
FROM schweizerischebundesbahnen/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV labels "was7"
ENV was7version "70"

# Download and extract WAS 70 and create profile
RUN cd /opt \
        &&  wget -qO- ${filerurl}/was-${was7version}.tar.gz | tar xfz - \
        && ln -s /opt/was70 ${jenkinshome}/buildtools/was70 \
        && /bin/bash ${jenkinshome}/buildtools/was70/profiles/default/bin/versionInfo.sh \
        && chown -R ${appuser}:${appuser} ${jenkinshome} /opt/was70*
		
# Link WAS JDK for Jenkins
RUN cd ${jenkinshome}/buildtools \
        && ln -s ${jenkinshome}/buildtools/was70/java ibm-jdk-was70 \
		&& ${jenkinshome}/buildtools/ibm-jdk-was70/bin/java -version
		
# Link custom keystore
RUN  cd ${jenkinshome}/buildtools \
	&& rm ./ibm-jdk-was70/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./ibm-jdk-was70/jre/lib/security/cacerts \
	&& ls -l ./ibm-jdk-was70/jre/lib/security/cacerts

# Create environment file
RUN echo 'export WAS7RUNTIME=/var/data/jenkins/buildtools/was70' >> ${jenkinshome}/env.sh

# Modify IBM JDK security settings
COPY java.security /opt/was70/java/jre/lib/security/java.security

# Start Slave
CMD echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive"
