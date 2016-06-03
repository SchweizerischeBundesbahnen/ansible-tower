FROM jenkinsci/jenkins:2.7
 
MAINTAINER lukas.elsner@sbb.ch

USER root

RUN apt-get update && apt-get install -y s3cmd openssl xmlstarlet p7zip-full ant ant-contrib && rm -rf /var/lib/apt/lists/*
RUN echo Europe/Zurich > /etc/timezone && sudo dpkg-reconfigure --frontend noninteractive tzdata

USER jenkins
