#Docker image for jenkins master
FROM registry.sbb.ch/base7
 
MAINTAINER igor.masen2@sbb.ch
 
ENV datadir /var/data
ENV appname jenkins-master
ENV appuser jenkins
ENV appversion 1.596.3
ENV offset 50
ENV JAVA_HOME /opt/jdk
ENV jenkinshome ${datadir}/${appname}

# Create Data directory structure and add user jenkins to the image
RUN mkdir -p ${datadir} \
	&& adduser ${appuser} -U -u 10${offset} --home ${jenkinshome} \
	&& mkdir -p ${jenkinshome}/{bin,m2,buildtools,.ssh} \
	&& echo "${appuser}:${appuser}" | chpasswd

# setting up locale
RUN echo "LC_ALL=en_US.UTF-8" >> ${jenkinshome}/.bashrc
 
# install basic tools
RUN yum install --quiet git -y \
	&& yum clean all -y
 
# add java opts to .bashrc file
RUN echo "export JAVA_HOME=${JAVA_HOME}" >> ${jenkinshome}/.bashrc

# download jenkins war
RUN wget --quiet http://mirrors.jenkins-ci.org/war-stable/${appversion}/jenkins.war -O /opt/jenkins.war \
	&& chown ${appuser}:${appuser} /opt/jenkins.war

# expose port 8050 for jenkins
EXPOSE 8050
# expose port 9050 for jenkins ajp
EXPOSE 9050
# expose port for slave communication JNLP
EXPOSE 10050
COPY configs/jenkins.sh /opt/jenkins.sh
USER jenkins
CMD "/opt/jenkins.sh"
