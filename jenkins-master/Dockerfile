#Docker image for jenkins master
FROM schweizerischebundesbahnen/jenkins-base
 
MAINTAINER igor.masen2@sbb.ch
 
ENV datadir /var/data
ENV appname jenkins
ENV appversion 1.565.3
ENV portoffset 90
ENV JAVA_OPTIONS -Xmx1024m -DJENKINS_HOME=/var/data/jenkins/jenkins
ENV JENKINS_HOME ${datadir}/${appname}
ENV JAVA_RUNTIME /opt/jdk17/bin/java

# create data directory
RUN mkdir -p /var/data
 
# setting up locale
RUN echo "LC_ALL=en_US.UTF-8" >> ${JENKINS_HOME}/.bashrc
 
# install basic tools
RUN yum install --quiet git curl zip -y && yum clean all -y
 


# get java
RUN wget --quiet --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz -O /opt/jdk17.tar.gz && cd /opt && tar xfz jdk17.tar.gz && ln -s /opt/jdk1.7* /opt/jdk17 && rm -rf /opt/*.tar.gz

# add java opts to .bashrc file
RUN echo "export JAVA_OPTIONS=${JAVA_OPTIONS}" >> ${JENKINS_HOME}/.bashrc

# download jenkins war
RUN wget --quiet http://mirrors.jenkins-ci.org/war-stable/${appversion}/jenkins.war -O /opt/jenkins.war && chown ${appname}:${appname} /opt/jenkins.war

# download plugins (@see: https://github.com/cloudbees/jenkins-ci.org-docker)
COPY configs/jenkins_plugins.txt /tmp/jenkins_plugins.txt
RUN mkdir -p /tmp/WEB-INF/plugins \
	&& for PLUGIN in `cat /tmp/jenkins_plugins.txt`; do  echo $PLUGIN; curl -k -L https://updates.jenkins-ci.org/latest/${PLUGIN}.hpi -o /tmp/WEB-INF/plugins/${PLUGIN}.hpi; done \
	&& cd /tmp \
	&& zip -r --grow /opt/jenkins.war WEB-INF/* \
	&& rm -rf /tmp/WEB-INF

# expose port 8050 for jenkins
EXPOSE 8050
# expose port 9050 for jenkins ajp
EXPOSE 9050
# expose port for slave communication
EXPOSE 9051

# supervisord: configure
COPY configs/jenkins.ini /etc/supervisor/conf.d/

# supervisor can not use env variables
RUN sed -ri "s#JAVA_PATH#${JAVA_RUNTIME}#g" /etc/supervisor/conf.d/jenkins.ini
RUN sed -ri "s#JAVA_OPTS#${JAVA_OPTIONS}#g" /etc/supervisor/conf.d/jenkins.ini 
RUN sed -ri "s/APP_USER/${appname}/g" /etc/supervisor/conf.d/jenkins.ini

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
