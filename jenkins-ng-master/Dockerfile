FROM jenkinsci/jenkins:latest
 
MAINTAINER lukas.elsner@sbb.ch

USER root

RUN apt-get update && apt-get install -y s3cmd openssl xmlstarlet p7zip-full ant ant-contrib && rm -rf /var/lib/apt/lists/*

USER jenkins
