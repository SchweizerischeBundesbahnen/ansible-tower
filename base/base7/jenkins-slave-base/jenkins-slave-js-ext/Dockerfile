# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM registry.sbb.ch/kd_wzu/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen@sbb.ch>

# Install js binaries for build
RUN yum update -q -y && yum install -q gcc freetype fontconfig GraphicsMagick  -y && yum clean all -q 

# Set npm-registry to SBB proxy manually (https://issues.sbb.ch/browse/WZU-4080,https://issues.sbb.ch/browse/MWESERVICE-8786)
RUN echo 'registry = http://repo.sbb-ext.net/content/groups/mirror.npm/' > ${jenkinshome}/.npmrc 

# Run jenkins
CMD su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive"