# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV labels "iib"
ENV buildtoolsdir /var/data/jenkins/buildtools
RUN yum install --quiet yum install libXext.i686 -y && yum clean all -y
# Download and extract wmbt
RUN cd  ${buildtoolsdir}/ &&  wget -qO- ${filerurl}/wmb.tar.gz | tar xfz - \
    &&  cd /var && wget -qO- ${filerurl}/ibm-wmb.tar.gz | tar xfz -

# Donwload and extract IIB9
RUN cd  ${buildtoolsdir}/ &&  wget -qO- ${filerurl}/IIB9002.tgz | tar xfz -

#RUN find ${buildtoolsdir}/wmb | grep mqsicreatebar

# Create environment file
RUN  echo "export WMB7RUNTIME=${buildtoolsdir}/wmb/WMBT700" >> ${jenkinshome}/env.sh
RUN  echo "export IIB9RUNTIME=${buildtoolsdir}/iib9" >> ${jenkinshome}/env.sh

# Chown jenkinshome
RUN chown -R ${appuser}:${appuser} ${jenkinshome}

# Start Slave
CMD su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels}  -mode exclusive"
