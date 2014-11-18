# This is the base Dockerfile for all SBB Dockerfiles @WZU
FROM centos:centos6

MAINTAINER Roger Bobst <roger.bobst@sbb.ch>

# The wzu user name used for ssh debug sessions to the running container
ENV wzuuser wzuuser
ENV JAVA_HOME /opt/jdk

# Open ports
EXPOSE 22

# Install packages
RUN yum install -q http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -y \
	&& yum update -y \
	&& yum -y install openssh-server wget curl tar python-setuptools sudo \
	&& yum clean all -q

# Install supervisor
RUN easy_install supervisor
RUN mkdir -p /etc/supervisor/conf.d

# supervisord: configure service and sshd
COPY configs/supervisord.conf /etc/supervisor/supervisord.conf
COPY configs/sshd.ini /etc/supervisor/conf.d/

# Change timezone to Europe/Zurich
RUN ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

# Till we use docker version 1.3 everywhere: add wzu debug user and add to sudoers
RUN /usr/sbin/useradd --create-home --home-dir /home/${wzuuser} --groups wheel --shell /bin/bash $wzuuser \
	&& echo "${wzuuser}:${wzuuser}" | chpasswd \
	&& echo "${wzuuser} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# init ssh service
# don't use pam in ssh
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
	&& sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN service sshd start && service sshd stop

# Get and Install Java
RUN curl -Lks --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz -o /opt/jdk17.tar.gz \
	&& cd /opt && tar xfz jdk17.tar.gz \
	&& ln -s /opt/jdk1.7* ${JAVA_HOME} \
	&& rm -rf /opt/*.tar.gz