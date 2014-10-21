#Base Image for atlassian products in WZU
#Leaned on https://bitbucket.org/atlassianlabs/atlassian-docker/ > base
FROM centos:centos6

MAINTAINER Sebastian Graf <sebastian.graf@sbb.ch>

#Installing enterprise packages and updating
RUN yum install -q http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -y
RUN yum update -q -y
#Installing wget and tar
RUN yum install -q sudo tar -y

# get java
RUN wget --quiet --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz -O /opt/jdk17.tar.gz && cd /opt && tar xfz jdk17.tar.gz && ln -s /opt/jdk1.7* /opt/jdk17 && rm -rf /opt/*.tar.gz

RUN /usr/sbin/groupadd atlassian
ADD own-volume.sh /usr/local/bin/own-volume
RUN echo "%atlassian ALL=NOPASSWD: /usr/local/bin/own-volume" >> /etc/sudoers

ADD common.bash /usr/local/share/atlassian/common.bash
RUN chgrp atlassian /usr/local/share/atlassian/common.bash
RUN chmod g+w /usr/local/share/atlassian/common.bash