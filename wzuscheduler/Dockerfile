#Docker image for jenkins master
FROM centos:centos6
 
MAINTAINER igor.masen2@sbb.ch
 
ENV datadir /var/data
ENV appname jenkins
ENV appversion 1.565.3
ENV portoffset 90
ENV maxheap 3072m
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
RUN yum install --quiet openssh-server git subversion vim wget curl tar -y && yum clean all -y
 
#Dont use Pam in ssh
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
# get java
RUN wget --quiet --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz -O /opt/jdk17.tar.gz && cd /opt && tar xfz jdk17.tar.gz && ln -s /opt/jdk1.7* /opt/jdk17 && rm -rf /opt/*.tar.gz
 
# get jenkins
RUN wget --quiet http://mirrors.jenkins-ci.org/war-stable/${appversion}/jenkins.war -O /opt/jenkins.war
 
# add java opts to .bashrc file
RUN echo "export JAVA_OPTIONS=${JAVA_OPTIONS}" >> ${JENKINS_HOME}/.bashrc
 
RUN /etc/init.d/sshd start
RUN mkdir -p ${JENKINS_HOME}/.ssh
RUN chown -R jenkins:jenkins ${JENKINS_HOME}/.ssh; chmod 700 ${JENKINS_HOME}/.ssh
EXPOSE 22
# start jenkins on container start
 
## Toggle to activate SSH access
#CMD service sshd start && su - jenkins -c "/opt/jdk17/bin/java -Xmx${maxheap} -jar /opt/jenkins.war -server"
 
CMD su - jenkins -c "/opt/jdk17/bin/java -Xmx${maxheap} -jar /opt/jenkins.war -server"
