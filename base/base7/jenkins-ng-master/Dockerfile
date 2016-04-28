FROM jenkins:latest
 
MAINTAINER lukas.elsner@sbb.ch

USER root

RUN yum install --quiet s3cmd git-svn openldap-clients openssl xmlstarlet p7zip p7zip-plugins which ant ant-contrib -y \
	&& yum clean all -y
