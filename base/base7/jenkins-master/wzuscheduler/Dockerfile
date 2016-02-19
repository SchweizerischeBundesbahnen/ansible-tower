#Docker image for wzuscheduler
FROM registry.sbb.ch/kd_wzu/jenkins-master
MAINTAINER igor.masen@sbb.ch

ENV appversion 1.625.3

# change back to root, to make changes on jenkins-master image
USER root

# install basic tools
RUN yum install --quiet s3cmd git-svn openldap-clients openssl xmlstarlet p7zip ant -y \
	&& yum clean all -y

# replace jenkins war
RUN rm -f /opt/jenkins.war \
    && wget --quiet http://repo.sbb.ch/content/groups/mirror/org/jenkins-ci/main/jenkins-war/${appversion}/jenkins-war-${appversion}.war -O /opt/jenkins.war \
	&& chown ${appuser}:${appuser} /opt/jenkins.war

# change back to jenkins to run jenkins
USER jenkins
