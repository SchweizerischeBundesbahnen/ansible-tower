# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM centos:centos6
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

#Environment variables
ENV jiraversion 6.2.7
ENV datadir /var/data
ENV jirahome /var/data/jira
ENV portoffset 70
ENV appuser jira
ENV filerurl http://wzufiler.sbb.ch 
ENV JAVA_HOME /opt/jdk17

# Install epel repo
RUN yum install -q http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -y && yum update -q -y && yum clean all

# Install a basic SSH server and some nice admin tools
RUN yum install -q openssh-server vim wget tar -y && yum clean all 

# Create Data directory structure and add user jira to the image
RUN mkdir -p ${datadir} && adduser jira -U -u 10${portoffset} --home ${jirahome}

# Set password for the jira user (you may want to alter this).
RUN echo "jira:jira" | chpasswd

# Download JDK 1.7 as jira runtime
RUN wget --quiet ${filerurl}/jdk17.tar.gz -O /tmp/jdk17.tar.gz && cd /opt/ && tar xfz /tmp/jdk17.tar.gz && rm -f /tmp/jdk17.tar.gz && ln -s /opt/jdk1.7* /opt/jdk17 && /opt/jdk17/bin/java -version

# Download jira into /opt
RUN wget --quiet http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-${jiraversion}.tar.gz -O /opt/atlassian-jira-${jiraversion}.tar.gz && cd /opt && tar xfz atlassian-jira-${jiraversion}.tar.gz && rm -f /opt/atlassian-jira-${jiraversion}.tar.gz && ln -s /opt/atlassian-jira* /opt/jira

# Chown ${jirahome} to jira
RUN chown -R jira:jira ${jirahome} /opt/atlassian-jira* /opt/jdk1.7*

# Set JIRA_HOME
RUN sed -i 's/#JIRA_HOME=""/JIRA_HOME=\/var\/data\/jira/g' /opt/jira/bin/setenv.sh

# Standard SSH port
EXPOSE 22

# Standard JIRA-Port AJP
EXPOSE 9070

# Standard JIRA-Port http
EXPOSE 8070

# Standard JIRA-Port JMX
EXPOSE 10070

# Start sshd daemon on container start
CMD ["server", "sshd", "start"]

# Start jira
#CMD ["server", "jira", "start"]

