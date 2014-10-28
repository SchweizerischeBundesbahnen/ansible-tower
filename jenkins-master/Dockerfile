#Docker image for jenkins master
FROM centos:centos6
 
MAINTAINER igor.masen2@sbb.ch
 
ENV datadir /var/data
ENV appname jenkins
ENV appversion 1.565.3
ENV portoffset 90
ENV JAVA_OPTIONS -Xmx1024m
ENV JENKINS_HOME ${datadir}/${appname}
ENV JENKINS_PLUGINS android-emulator \
ant \
antisamy-markup-formatter \
audit-trail \
backup \
blame-upstream-commiters \
build-blocker-plugin \
build-pipeline-plugin \
claim \
console-column-plugin \
credentials \
cron_column \
email-ext \
embeddable-build-status \
extended-choice-parameter \
external-monitor-job \
git \
git-client \
greenballs \
hp-application-automation-tools-plugin \
javadoc \
jobConfigHistory \
jquery \
ldap \
log-parser \
m2release \
mailer \
mapdb-api \
mask-passwords \
matrix-auth \
matrix-project \
maven-plugin \
msbuild \
mstest \
nested-view \
pam-auth \
parameterized-trigger \
port-allocator \
publish-over-ssh \
scm-api \
slave-status \
sonar \
ssh-agent \
ssh-credentials \
ssh-slaves \
stashNotifier \
subversion \
swarm \
systemloadaverage-monitor \
timestamper \
token-macro \
vstestrunner \
windows-slaves \
xcode-plugin \
xfpanel \
xvfb

# create data directory
RUN mkdir -p /var/data
 
# create user
RUN adduser -u 10${portoffset} -U ${appname} -b ${datadir}

# setting up locale
RUN echo "LC_ALL=en_US.UTF-8" >> ${JENKINS_HOME}/.bashrc
 
# install basic tools
RUN yum install --quiet openssh-server git subversion vim wget curl tar zip unzip  -y && yum clean all -y
 
# don't use pam in ssh
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# start ssh daemon
RUN /etc/init.d/sshd start
RUN mkdir -p ${JENKINS_HOME}/.ssh
RUN chown -R ${appname}:${appname} ${JENKINS_HOME}/.ssh; chmod 700 ${JENKINS_HOME}/.ssh
EXPOSE 22

# get java
RUN wget --quiet --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz -O /opt/jdk17.tar.gz && cd /opt && tar xfz jdk17.tar.gz && ln -s /opt/jdk1.7* /opt/jdk17 && rm -rf /opt/*.tar.gz

# add java opts to .bashrc file
RUN echo "export JAVA_OPTIONS=${JAVA_OPTIONS}" >> ${JENKINS_HOME}/.bashrc

# download jenkins war
RUN wget --quiet http://mirrors.jenkins-ci.org/war-stable/${appversion}/jenkins.war -O /opt/jenkins.war && chown ${appname}:${appname} /opt/jenkins.war

# create custom run.sh without ssh
RUN echo "/opt/jdk17/bin/java ${JAVA_OPTS} -jar /opt/jenkins.war -server" >> /opt/run.sh

# download plugins (@see: https://github.com/cloudbees/jenkins-ci.org-docker)
RUN mkdir -p /tmp/WEB-INF/plugins
RUN for PLUGIN in $JENKINS_PLUGINS; do  echo $PLUGIN; curl -k -L https://updates.jenkins-ci.org/latest/${PLUGIN}.hpi -o /tmp/WEB-INF/plugins/${PLUGIN}.hpi; done
RUN cd /tmp && zip -r --grow /opt/jenkins.war WEB-INF/*

# expose port 8080 for jenkins
EXPOSE 8080

# start jenkins on container start without ssh
CMD su - ${appname} -c "sh /opt/run.sh"
 
# start jenkins on container start with ssh
#CMD service sshd start && su - ${appname} -c "sh /opt/run.sh"

