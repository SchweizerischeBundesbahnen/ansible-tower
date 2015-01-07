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

# supervisord: configure service and sshd
COPY configs/supervisord.conf /etc/supervisor/supervisord.conf

# Change timezone to Europe/Zurich
RUN ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

# Get and Install Java
RUN curl -Lks --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz -o /opt/jdk17.tar.gz \
	&& cd /opt && tar xfz jdk17.tar.gz \
	&& ln -s /opt/jdk1.7* ${JAVA_HOME} \
	&& rm -rf /opt/*.tar.gz

# install swisscom root cert
COPY configs/Swisscom_Root.cer /opt/jdk/Swisscom_Root.cer
RUN /opt/jdk/jre/bin/keytool -import -noprompt -keystore /opt/jdk/jre/lib/security/cacerts -file /opt/jdk/Swisscom_Root.cer  -storepass "changeit" \
	&& rm /opt/jdk/Swisscom_Root.cer 
