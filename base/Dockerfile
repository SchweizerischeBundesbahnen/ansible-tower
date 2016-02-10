# This is the base Dockerfile for all SBB Dockerfiles @WZU
FROM centos:centos7

MAINTAINER Roger Bobst <roger.bobst@sbb.ch>

# SVN is used as filerurl
ENV fileruser fswzuad
ENV filerpassword bolb3fas
ENV filerurl https://${fileruser}:${filerpassword}@svn.sbb.ch/svn/wzu
ENV TZ Europe/Zurich

# The CA for svn.sbb.ch
ENV telesec_ssl ${filerurl}/telesec_serverpass_ca_1.der

# wzu keystore
ENV keystore keystore-20150722

# The wzu user name used for ssh debug sessions to the running container
ENV JAVA_HOME /opt/jdk

# Install packages
RUN yum install -q http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm -y \
	&& yum update -y \
	&& yum -y install wget git subversion curl tar zip unzip sudo bzip2 \
	&& yum clean all -q

# Install telesec serverpass to trust svn.sbb.ch (used in filerurl variable)
RUN curl --insecure -s ${telesec_ssl} -o /etc/pki/ca-trust/source/anchors/telesec_serverpass_ca_1.der \
		&& update-ca-trust enable \
		&& update-ca-trust

# Set locale to en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN echo "export LC_ALL=en_US.UTF-8" > /etc/profile.d/lang.sh

# Change timezone to Europe/Zurich
RUN ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

