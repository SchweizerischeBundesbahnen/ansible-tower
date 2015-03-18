# This Dockerfile is used to build an image containing basic stuff to build other docker images
FROM ubuntu:trusty
MAINTAINER Roger Bobst <roger.bobst@sbb.ch>


# Env vars for docker docker slave
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


# install stuff for docker installation
RUN apt-get update -qq \
	&& apt-get install -y apt-transport-https ca-certificates curl lxc iptables

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ubuntu/ | sh

# Add start scripts
ADD configs/wrapdocker /usr/local/bin/wrapdocker
ADD configs/start-slave.sh /usr/local/bin/start-slave.sh
RUN chmod +x /usr/local/bin/wrapdocker \
	&& chmod +x /usr/local/bin/start-slave.sh

VOLUME /var/lib/docker


# stuff from base
# Change timezone to Europe/Zurich
RUN ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

# Get and Install Java
RUN curl -Lks --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz -o /opt/jdk17.tar.gz \
	&& cd /opt && tar xfz jdk17.tar.gz \
	&& ln -s /opt/jdk1.7* ${JAVA_HOME} \
	&& rm -rf /opt/*.tar.gz

# Install WZU Keystore
RUN wget --quiet http://wzufiler.sbb.ch/keystore -O /opt/jdk/jre/lib/security/cacerts

# stuff from slave-base
# Create Data directory structure and add user jenkins to the image
RUN mkdir -p ${datadir} \
	&& adduser ${appuser} --uid 1091 --home ${jenkinshome} \
	&& usermod -a -G docker ${appuser} \
	&& mkdir -p ${jenkinshome}/bin \
	&& mkdir -p ${jenkinshome}/m2 \
	&& mkdir -p ${jenkinshome}/buildtools \
	&& mkdir -p ${jenkinshome}/.ssh \
	&& mkdir -p ${jenkinshome}/temp \
	&& echo "${appuser}:${appuser}" | chpasswd

# Download the swarm client
RUN wget --quiet "http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/${swarmversion}/swarm-client-${swarmversion}-jar-with-dependencies.jar" -O ${jenkinshome}/swarm-client.jar

# Create environment file
RUN echo 'export PATH=$PATH:$HOME/bin:/opt/jdk/bin\nLC_ALL=en_US.UTF-8' >> ${jenkinshome}/env.sh

# Disable Hostkeychecks for ssh for enabling batch-based git clones: https://issues.sbb.ch/browse/MWESERVICE-4234
RUN echo -e "Host code.sbb.ch\n\tStrictHostKeyChecking no\n">> ${jenkinshome}/.ssh/config && chmod 644 ${jenkinshome}/.ssh/config

# Disable ssl Verify
RUN echo "[http]\n\tsslVerify = false">> ${jenkinshome}/.gitconfig

# Add jenkins user to sudoers
RUN echo "jenkins ALL=(ALL:ALL) NOPASSWD: ALL">> /etc/sudoers

# Add environment variables to run on start
RUN wget --quiet ${filerurl}/keystore -O ${jenkinshome}/.keystore

# Start Slave
CMD /usr/local/bin/start-slave.sh ${externalport} ${host} ${jenkinshome} ${appuser} ${executors} ${master} ${slavename} ${ciuser} ${cipassword} ${labels}
