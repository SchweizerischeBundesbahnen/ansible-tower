# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV labels "swarm nodejs"


# Install js binaries for build
RUN yum update -q -y && yum install -q nodejs npm rubygems  -y && yum clean all -q 

# Install packages for build
RUN npm install bower grunt grunt-cli gulp --silent && gem install bundle

# Add node binaries to path
RUN echo 'export PATH=$PATH:/node_modules/.bin' >> ${jenkinshome}/env.sh

# Chown jenkinshome
RUN chown -R ${appuser}:${appuser} ${jenkinshome}

# Run jenkins
CMD echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive"
