#! /bin/bash
# Installationsskript für JRebel-Lizenzserver
# Docker simulieren auf RHEL 6.x....
# @see WZU-3216 Switchover JRebel-Lizenzserver

export appversion=3.0.4
export appuser=jrebellicense
export idoffset=150
export datadir=/var/data
export apphome=/var/data/jrebellicenseserver
export PATH=/usr/local/bin:/sbin:/usr/sbin:/usr/bin:/bin


export JAVA_HOME=/opt/jdk

# Install packages
yum update -y && yum -y install wget curl tar zip unzip python-setuptools sudo bzip2 && yum clean all -q


# Set locale to en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
echo "export LC_ALL=en_US.UTF-8" > /etc/profile.d/lang.sh


# Change timezone to Europe/Zurich
ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

# Get and Install Java
curl -Lks --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz -o /opt/jdk17.tar.gz \
	&& cd /opt && tar xfz jdk17.tar.gz \
	&& ln -s /opt/jdk1.7* ${JAVA_HOME} \
	&& rm -rf /opt/*.tar.gz

# Install WZU Keystore
wget --quiet http://wzufiler.sbb.ch/keystore -O /opt/jdk/jre/lib/security/cacerts


# Create Data directory structure and add user jira to the image
mkdir -p ${datadir}/ && adduser ${appuser} -U -u 10${idoffset} --home ${apphome} && mkdir -p ${apphome}/license-server


# Get the license-server
cd /opt && wget -q "http://dl.zeroturnaround.com/license-server/license-server-${appversion}.zip"  -O license-server-${appversion}.zip && unzip license-server-${appversion}.zip && rm license-server-${appversion}.zip