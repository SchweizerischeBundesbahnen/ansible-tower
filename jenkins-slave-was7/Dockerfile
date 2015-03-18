FROM schweizerischebundesbahnen/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>
MAINTAINER Christoph Glanzmann <christoph.glanzmann@sbb.ch>

ENV labels "was7"

# Download and extract WAS 70 and create profile
RUN cd /opt \
        &&  wget -qO- ${filerurl}/was70.tar.gz | tar xfz - \
        && ln -s /opt/was70 ${jenkinshome}/buildtools/was70 \
        && /bin/bash ${jenkinshome}/buildtools/was70/profiles/default/bin/versionInfo.sh \
        && chown -R ${appuser}:${appuser} ${jenkinshome} /opt/was70*

# Link WAS70 JDK to the right place
RUN cd ${jenkinshome}/buildtools && ln -s /opt/was70/java ibm-jdk-was70 && ${jenkinshome}/buildtools/ibm-jdk-was70/bin/java -version

# Legacy stuff
RUN cd ${jenkinshome}/buildtools && ln -s was70 base_v70

# Create environment file
RUN echo 'export WAS7RUNTIME=/var/data/jenkins/buildtools/was70 >> ${jenkinshome}/env.sh

# Modify IBM JDK security settings
COPY java.security /opt/was70/java/jre/lib/security/java.security

# Start Slave
CMD echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive"
