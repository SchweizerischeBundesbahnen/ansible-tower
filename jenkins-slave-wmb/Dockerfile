# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV labels "wmb"
ENV buildtoolsdir /var/data/jenkins/buildtools

# Download and extract wmb
RUN cd  ${buildtoolsdir}/ \
	&&  wget -qO- ${filerurl}/wmb.tar.gz | tar xfz - \
	&&  cd /var \
	&& wget -qO- ${filerurl}/ibm-wmb.tar.gz | tar xfz - \
	&& chown -R ${appuser}:${appuser} ${jenkinshome}

# Create environment file
RUN  echo "export WMB7RUNTIME=${buildtoolsdir}/wmb/WMBT700" >> ${jenkinshome}/env.sh \
	&& chown -R ${appuser}:${appuser} ${jenkinshome}/env.sh

# Start Slave
CMD echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels}  -mode exclusive"
