# This Dockerfile is used to build an image containing basic stuff to build other docker images
FROM jpetazzo/dind
MAINTAINER Roger Bobst <roger.bobst@sbb.ch>

ENV labels "docker"
ENV JAVA_HOME /opt/jdk

ENV appuser jenkins
ENV datadir /var/data 
ENV jenkinshome ${datadir}/jenkins
ENV portoffset 91
ENV swarmversion 1.22
ENV master http://ci-t.sbb.ch
ENV executors 1
ENV filerurl http://wzufiler.sbb.ch
ENV labels swarm
ENV slavename $labels
ENV externalport 12345 
ENV host example.sbb.ch


# stuff from base
# Change timezone to Europe/Zurich
RUN ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

# Get and Install Java
RUN curl -Lks --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz -o /opt/jdk17.tar.gz \
	&& cd /opt && tar xfz jdk17.tar.gz \
	&& ln -s /opt/jdk1.7* ${JAVA_HOME} \
	&& rm -rf /opt/*.tar.gz

# install swisscom root cert
COPY configs/Swisscom_Root.cer /opt/jdk/Swisscom_Root.cer
RUN /opt/jdk/jre/bin/keytool -import -noprompt -keystore /opt/jdk/jre/lib/security/cacerts -file /opt/jdk/Swisscom_Root.cer  -storepass "changeit" \
	&& rm /opt/jdk/Swisscom_Root.cer 


# stuff from slave-base
# Create Data directory structure and add user jenkins to the image
RUN mkdir -p ${datadir} \
	&& adduser ${appuser} --uid 1091 --home ${jenkinshome} \
	&& mkdir -p ${jenkinshome}/bin \
	&& mkdir -p ${jenkinshome}/m2 \
	&& mkdir -p ${jenkinshome}/buildtools \
	&& mkdir -p ${jenkinshome}/.ssh \
	&& mkdir -p ${jenkinshome}/temp \
	&& echo "${appuser}:${appuser}" | chpasswd

# Download the swarm client
RUN wget --quiet "http://repo.sbb.ch/content/repositories/mirror/org/jenkins-ci/plugins/swarm-client/${swarmversion}/swarm-client-${swarmversion}-jar-with-dependencies.jar" -O ${jenkinshome}/swarm-client.jar

# Create environment file
RUN echo 'export PATH=$PATH:$HOME/bin:/opt/jdk/bin LC_ALL=en_US.UTF-8' >> ${jenkinshome}/env.sh

# Disable Hostkeychecks for ssh for enabling batch-based git clones: https://issues.sbb.ch/browse/MWESERVICE-4234
RUN echo -e "Host code.sbb.ch\n\tStrictHostKeyChecking no\n">> ${jenkinshome}/.ssh/config && chmod 644 ${jenkinshome}/.ssh/config

# Add environment variables to run on start
RUN wget --quiet ${filerurl}/keystore -O ${jenkinshome}/.keystore
#	&& chmod +x ${jenkinshome}/run.sh

# Start Slave
CMD echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive"
