#Docker image for wzuscheduler
FROM schweizerischebundesbahnen/jenkins-master
MAINTAINER pascal.bieri@sbb.ch

ENV appversion 1.625.3

# install basic tools
RUN yum install --quiet s3cmd git-svn openldap-clients openssl xmlstarlet -y \
	&& yum clean all -y

# replace jenkins war
RUN rm -f /opt/jenkins.war \
    && wget --quiet http://repo.sbb.ch/content/groups/mirror/org/jenkins-ci/main/jenkins-war/${appversion}/jenkins-war-${appversion}.war -O /opt/jenkins.war \
	&& chown ${appuser}:${appuser} /opt/jenkins.war
