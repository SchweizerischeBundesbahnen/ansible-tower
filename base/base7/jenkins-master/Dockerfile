#Docker image for jenkins master
FROM schweizerischebundesbahnen/base7
 
MAINTAINER igor.masen2@sbb.ch
 
ENV datadir /var/data
ENV appname jenkins
ENV appuser jenkins
ENV appversion 1.596.3
ENV offset 50
ENV JAVA_OPTIONS -Xmx1024m -DJENKINS_HOME=${datadir}/${appname}
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
RUN echo "export JAVA_OPTIONS=${JAVA_OPTIONS}" >> ${jenkinshome}/.bashrc

# download jenkins war
RUN wget --quiet http://mirrors.jenkins-ci.org/war-stable/${appversion}/jenkins.war -O /opt/jenkins.war \
	&& chown ${appname}:${appname} /opt/jenkins.war

# expose port 8050 for jenkins
EXPOSE 8050
# expose port 9050 for jenkins ajp
EXPOSE 9050
# expose port for slave communication
EXPOSE 9051

# supervisord: configure
COPY configs/jenkins.ini /etc/supervisor/conf.d/

# supervisor can not use env variables
RUN sed -ri "s#JAVA_PATH#${JAVA_HOME}/bin/java#g" /etc/supervisor/conf.d/jenkins.ini
RUN sed -ri "s#JAVA_OPTS#${JAVA_OPTIONS}#g" /etc/supervisor/conf.d/jenkins.ini 
RUN sed -ri "s/APP_USER/${appname}/g" /etc/supervisor/conf.d/jenkins.ini

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
