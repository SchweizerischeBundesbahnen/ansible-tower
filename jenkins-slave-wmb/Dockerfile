# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV labels "wmb"
ENV buildtoolsdir /var/data/jenkins/buildtools

# Download and extract wmbt
RUN mkdir -p ${buildtoolsdir} \
        &&  cd  ${buildtoolsdir}/ &&  wget -qO- ${filerurl}/wmb.tar.gz | tar xfz - \
        &&  cd /var && wget -qO- ${filerurl}/ibm-wmb.tar.gz | tar xfz -

#RUN find ${buildtoolsdir}/wmb | grep mqsicreatebar

# Create environment file
RUN  echo "export WMB7RUNTIME=${buildtoolsdir}/wmb/WMBT700" >> ${jenkinshome}/env.sh

# Chown jenkinshome
RUN chown -R ${appuser}:${appuser} ${jenkinshome}

# Start Slave
CMD su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -username ${ciuser} -password ${cipassword} -labels ${labels}"
