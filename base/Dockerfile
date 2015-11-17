# This is the base Dockerfile for all SBB Dockerfiles @WZU
FROM centos:centos7

MAINTAINER Roger Bobst <roger.bobst@sbb.ch>

# The CA for svn.sbb.ch
ENV telesec_ssl https://svn.sbb.ch/svn/wzu/telesec_serverpass_ca_1.der 

# SVN is used as filerurl
ENV filerurl https://fsvctip:sommer11@svn.sbb.ch/svn/wzu

# The wzu user name used for ssh debug sessions to the running container
ENV JAVA_HOME /opt/jdk

# Install packages
RUN yum install -q http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm -y \
	&& yum update -y \
	&& yum -y install wget curl tar zip unzip python-setuptools sudo bzip2 \
	&& yum clean all -q

# Install telesec serverpass to trust svn.sbb.ch (used in filerurl variable)
RUN curl --insecure ${telesec_ssl} -o /etc/pki/ca-trust/source/anchors/telesec_serverpass_ca_1.der

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

