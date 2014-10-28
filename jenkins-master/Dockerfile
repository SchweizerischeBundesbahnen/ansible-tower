#Docker image for jenkins master
FROM centos:centos6
 
MAINTAINER igor.masen2@sbb.ch
 
ENV datadir /var/data
ENV appname jenkins
ENV appversion 1.565.3
ENV portoffset 90
ENV JAVA_OPTIONS -Xmx1024m
ENV JENKINS_HOME ${datadir}/${appname}
 
# create data directory
RUN mkdir -p /var/data
 
# create user
RUN adduser -u 10${portoffset} -U ${appname} -b ${datadir}

# setting up locale
RUN echo "LC_ALL=en_US.UTF-8" >> ${JENKINS_HOME}/.bashrc
 
# install basic tools
RUN yum install --quiet openssh-server git subversion vim wget curl tar zip unzip  -y && yum clean all -y
 
# don't use pam in ssh
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# start ssh daemon
RUN /etc/init.d/sshd start
RUN mkdir -p ${JENKINS_HOME}/.ssh
RUN chown -R ${appname}:${appname} ${JENKINS_HOME}/.ssh; chmod 700 ${JENKINS_HOME}/.ssh
EXPOSE 22

# get java
RUN wget --quiet --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz -O /opt/jdk17.tar.gz && cd /opt && tar xfz jdk17.tar.gz && ln -s /opt/jdk1.7* /opt/jdk17 && rm -rf /opt/*.tar.gz

# add java opts to .bashrc file
RUN echo "export JAVA_OPTIONS=${JAVA_OPTIONS}" >> ${JENKINS_HOME}/.bashrc

# download jenkins war
RUN wget --quiet http://mirrors.jenkins-ci.org/war-stable/${appversion}/jenkins.war -O /opt/jenkins.war && chown ${appname}:${appname} /opt/jenkins.war

# create custom run.sh without ssh
RUN echo "/opt/jdk17/bin/java ${JAVA_OPTS} -jar /opt/jenkins.war -server" >> /opt/run.sh

# download plugins (@see: https://github.com/cloudbees/jenkins-ci.org-docker)
RUN mkdir -p /tmp/WEB-INF/plugins
RUN curl -k -L https://updates.jenkins-ci.org/latest/git.hpi -o /tmp/WEB-INF/plugins/git.hpi
RUN curl -k curl -L https://updates.jenkins-ci.org/latest/git-client.hpi -o /tmp/WEB-INF/plugins/git-client.hpi
RUN cd /tmp && zip --grow /opt/jenkins.war WEB-INF/*

# expose port 8080 for jenkins
EXPOSE 8080

# start jenkins on container start without ssh
CMD su - ${appname} -c "sh /opt/run.sh"
 
# start jenkins on container start with ssh
#CMD service sshd start && su - ${appname} -c "sh /opt/run.sh"

