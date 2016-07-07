FROM jenkinsci/jenkins:2.11
 
MAINTAINER lukas.elsner@sbb.ch

USER root

RUN apt-get update && apt-get install -y ansible s3cmd openssl xmlstarlet p7zip-full ant ant-contrib ldap-utils build-essential rsync && rm -rf /var/lib/apt/lists/*
RUN echo Europe/Zurich > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
RUN usermod -d /var/data/jenkins-master jenkins

USER jenkins
