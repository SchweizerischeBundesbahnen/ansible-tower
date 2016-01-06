#Docker image for jenkins master
FROM schweizerischebundesbahnen/base7
 
MAINTAINER igor.masen@sbb.ch
 
ENV datadir /var/data
ENV appname jenkins-master
ENV appuser jenkins
ENV appversion 1.596.3
ENV offset 50
ENV JAVA_HOME /opt/jdk
ENV jenkinshome ${datadir}/${appname}

# Create Data directory structure and add user jenkins to the image
RUN mkdir -p ${datadir} \
	&& adduser ${appuser} -U -u 10${offset} --home ${jenkinshome}

# download jenkins war
RUN wget --quiet http://repo.sbb.ch/content/groups/mirror/org/jenkins-ci/main/jenkins-war/${appversion}/jenkins-war-${appversion}.war -O /opt/jenkins.war \
	&& chown ${appuser}:${appuser} /opt/jenkins.war

# expose port 8050 for jenkins
EXPOSE 8050
# expose port 9050 for jenkins ajp
EXPOSE 9050
# expose port for JMX
EXPOSE 10050
# expose port for slave communication jnlp
EXPOSE 9051
COPY configs/jenkins.sh /opt/jenkins.sh
USER jenkins
CMD "/opt/jenkins.sh"
