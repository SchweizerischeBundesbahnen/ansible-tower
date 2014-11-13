#Docker image for jenkins master
FROM schweizerischebundesbahnen/jenkins-base
#FROM centos:centos6
 
MAINTAINER igor.masen2@sbb.ch
 
ENV datadir /var/data
ENV appname jenkins
ENV appversion 1.565.3
ENV portoffset 90
ENV JAVA_OPTIONS -Xmx1024m
ENV JENKINS_HOME ${datadir}/${appname}
ENV JAVA_RUNTIME /opt/jdk17/bin/java

# create data directory
RUN mkdir -p /var/data
 
# setting up locale
RUN echo "LC_ALL=en_US.UTF-8" >> ${JENKINS_HOME}/.bashrc
 
# install basic tools
RUN yum install --quiet openssh-server git subversion vim wget curl tar zip unzip  -y && yum clean all -y
 
# don't use pam in ssh
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# get java
RUN wget --quiet --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz -O /opt/jdk17.tar.gz && cd /opt && tar xfz jdk17.tar.gz && ln -s /opt/jdk1.7* /opt/jdk17 && rm -rf /opt/*.tar.gz

# add java opts to .bashrc file
RUN echo "export JAVA_OPTIONS=${JAVA_OPTIONS}" >> ${JENKINS_HOME}/.bashrc

# download jenkins war
RUN wget --quiet http://mirrors.jenkins-ci.org/war-stable/${appversion}/jenkins.war -O /opt/jenkins.war && chown ${appname}:${appname} /opt/jenkins.war

# create custom run.sh without ssh
RUN echo "${JAVA_PATH} ${JAVA_OPTS} -jar /opt/jenkins.war -server" >> /opt/run.sh

# download plugins (@see: https://github.com/cloudbees/jenkins-ci.org-docker)
ENV JENKINS_PLUGINS android-emulator \
audit-trail \
backup \
blame-upstream-commiters \
build-blocker-plugin \
build-pipeline-plugin \
claim \
console-column-plugin \
cron_column \
email-ext \
embeddable-build-status \
extended-choice-parameter \
git \
git-client \
greenballs \
hp-application-automation-tools-plugin \
jobConfigHistory \
jquery \
log-parser \
m2release \
mapdb-api \
mask-passwords \
msbuild \
mstest \
nested-view \
parameterized-trigger \
port-allocator \
publish-over-ssh \
scm-api \
slave-status \
sonar \
ssh-agent \
stashNotifier \
swarm \
systemloadaverage-monitor \
timestamper \
token-macro \
vstestrunner \
xcode-plugin \
xfpanel \
xvfb
RUN mkdir -p /tmp/WEB-INF/plugins
RUN for PLUGIN in $JENKINS_PLUGINS; do  echo $PLUGIN; curl -k -L https://updates.jenkins-ci.org/latest/${PLUGIN}.hpi -o /tmp/WEB-INF/plugins/${PLUGIN}.hpi; done
RUN cd /tmp && zip -r --grow /opt/jenkins.war WEB-INF/*

# expose port 8080 for jenkins
EXPOSE 8080

# init ssh service
RUN service sshd start

# expose ssh port
EXPOSE 22

# install supervisord
# FIXME: move this into base class
RUN yum -y install python-setuptools sudo && yum clean all
RUN easy_install supervisor
RUN mkdir -p /etc/supervisor/conf.d

ENV wzuuser wzuuser
RUN /usr/sbin/useradd --create-home --home-dir /home/${wzuuser} --groups wheel --shell /bin/bash $wzuuser
RUN echo "${wzuuser}:${wzuuser}" | chpasswd
RUN echo "${wzuuser} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# supervisord: configure
COPY configs/supervisord.conf /etc/supervisor/supervisord.conf
COPY configs/jenkins.ini /etc/supervisor/conf.d/
COPY configs/sshd.ini /etc/supervisor/conf.d/

# supervisor can not use env variables
RUN sed -ri "s#JAVA_PATH#${JAVA_RUNTIME}#g" /etc/supervisor/conf.d/jenkins.ini
RUN sed -ri "s/JAVA_OPTS/${JAVA_OPTIONS}/g" /etc/supervisor/conf.d/jenkins.ini 
RUN sed -ri "s/APP_USER/${appname}/g" /etc/supervisor/conf.d/jenkins.ini

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
