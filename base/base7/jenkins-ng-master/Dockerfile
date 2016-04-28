#Docker image for jenkins master
FROM jenkins
 
MAINTAINER lukas.elsner@sbb.ch

USER root

# install basic tools
RUN yum install --quiet s3cmd git-svn openldap-clients openssl xmlstarlet p7zip p7zip-plugins which ant ant-contrib -y \
	&& yum clean all -y
