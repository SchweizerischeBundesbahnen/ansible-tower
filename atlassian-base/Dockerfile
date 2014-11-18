#Base Image for atlassian products in WZU
#Leaned on https://bitbucket.org/atlassianlabs/atlassian-docker/ > base
FROM schweizerischebundesbahnen/base

MAINTAINER Sebastian Graf <sebastian.graf@sbb.ch>

#Installing enterprise packages and installing supervisor packages
RUN yum install -q http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -y && yum install -q -y sudo tar python-setuptools openssh-server wget && yum clean all && yum update -q -y

#Installing supervisor
RUN easy_install supervisor

#Making folder and copying the inis
RUN mkdir -p /etc/supervisor/conf.d
# supervisord: configure
COPY configs/supervisord.conf /etc/supervisor/supervisord.conf
COPY configs/sshd.ini /etc/supervisor/conf.d/

# expose ssh port
EXPOSE 22

#SSH stuff
ENV wzuuser wzuuser
RUN /usr/sbin/useradd --create-home --home-dir /home/${wzuuser} --groups wheel --shell /bin/bash $wzuuser
RUN echo "${wzuuser}:${wzuuser}" | chpasswd
RUN echo "${wzuuser} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# don't use pam in ssh
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# init ssh service
RUN service sshd start

# get java
RUN curl -Lks --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz -o /opt/jdk17.tar.gz && cd /opt && tar xfz jdk17.tar.gz && ln -s /opt/jdk1.7* /opt/jdk && rm -rf /opt/*.tar.gz
