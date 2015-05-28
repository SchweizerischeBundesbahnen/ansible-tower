# This is the base Dockerfile for all SBB Dockerfiles @WZU
FROM centos:centos7

MAINTAINER Roger Bobst <roger.bobst@sbb.ch>

# The wzu user name used for ssh debug sessions to the running container
ENV JAVA_HOME /opt/jdk

# Install packages
RUN yum install -q http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm -y \
	&& yum update -y \
	&& yum -y install wget curl tar zip unzip python-setuptools sudo bzip2 \
	&& yum clean all -q

# Install supervisor
RUN easy_install supervisor
RUN mkdir -p /etc/supervisor/conf.d

# Supervisord: configure service and sshd
COPY configs/supervisord.conf /etc/supervisor/supervisord.conf

# Set locale to en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN echo "export LC_ALL=en_US.UTF-8" > /etc/profile.d/lang.sh

# Change timezone to Europe/Zurich
RUN ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

