FROM jenkinsci/jenkins:2.9
 
MAINTAINER lukas.elsner@sbb.ch

USER root

RUN apt-get update && apt-get install -y s3cmd openssl xmlstarlet p7zip-full ant ant-contrib ldap-utils build-essential && rm -rf /var/lib/apt/lists/*
RUN echo Europe/Zurich > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
RUN usermod -d /var/data/jenkins-master jenkins

USER jenkins