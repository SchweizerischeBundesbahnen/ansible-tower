#Docker image for jenkins master
FROM registry-t.sbb.ch/base:WZU-3017
MAINTAINER pascal.bieri@sbb.ch

ENV datadir /var/data
ENV appname jenkins
ENV appversion 1.580.2
ENV portoffset 90
ENV maxheap 2048m
ENV JENKINS_HOME ${datadir}/${appname}

# create data directory
RUN mkdir -p /var/data

# create user
RUN adduser -u 10${portoffset} -U ${appname} -b ${datadir}

# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

# setting up locale
RUN echo "LC_ALL=en_US.UTF-8" >> ${JENKINS_HOME}/.bashrc

# install basic tools
RUN yum install --quiet git subversion -y && yum clean all -y

# Change timezone to Europe/Zurich
RUN ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

# get jenkins
RUN wget --quiet http://mirrors.jenkins-ci.org/war-stable/${appversion}/jenkins.war -O /opt/jenkins.war

# add java opts to .bashrc file
RUN echo "export JAVA_OPTIONS=${JAVA_OPTIONS}" >> ${JENKINS_HOME}/.bashrc

# start jenkins on container start
EXPOSE 8080
## Toggle to activate SSH access
#CMD service sshd start && su - jenkins -c "/opt/jdk17/bin/java -Xmx${maxheap} -jar /opt/jenkins.war -server"

CMD su - jenkins -c "/opt/jdk/bin/java -Xmx${maxheap} -jar /opt/jenkins.war -server"
