# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/jenkins-slave-base
MAINTAINER Pascal Bieri <pascal.bieri@sbb.ch>

ENV labels "iib"
ENV buildtoolsdir /var/data/jenkins/buildtools
ENV iib9version "9.0.0.201-1"
ENV additional_args ""
RUN yum install --quiet yum install libXext.i686 libXtst.i686 expect xorg-x11-server-Xvfb gtk2.i686 -y && yum clean all -y

# Download and extract wmb
RUN cd  ${buildtoolsdir}/ \
	&&  wget -qO- ${filerurl}/jenkins-iib${iib9version}.tgz | tar xfz - \
	&&  mkdir /var/ibm \
	&& cd /var/ibm \
	&& wget -qO- ${filerurl}/InstallationManager90.tgz | tar xfz - \
	&& chown -R ${appuser}:${appuser} ${jenkinshome}

# Create environment file
RUN  echo "export IIB9RUNTIME=${buildtoolsdir}/iib9/IntegrationToolkit90" >> ${jenkinshome}/env.sh \
	&& chown -R ${appuser}:${appuser} ${jenkinshome}/env.sh

RUN echo "Xvfb :1 -screen 0 1024x768x16 &> /tmp/xvfb.log &" >> ${jenkinshome}/run.sh && echo "export DISPLAY=:1.0" >> ${jenkinshome}/env.sh

# Start Slave
CMD echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -username ${ciuser} -name ${slavename} -password ${cipassword} -labels ${labels}  -mode exclusive ${additional_args}"
