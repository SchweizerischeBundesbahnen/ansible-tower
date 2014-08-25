# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM centos:centos6
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

#Environment variables
ENV mvn30version 3.0.5
ENV mvn31version 3.1.1
ENV mvn32version 3.2.3
ENV swarmversion 1.16
ENV datadir /var/data 
ENV jenkinshome ${datadir}/jenkins
ENV master http://ci-t.sbb.ch
ENV user fsvctip
ENV password sommer11
ENV executors 4
ENV filerurl http://wzufiler.sbb.ch 

# Install epel repo
RUN yum install -q http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -y && yum update -q -y && yum clean all

# Install a basic SSH server and some nice admin tools
RUN yum install -q openssh-server vim wget tar subversion git glibc.i686 libgcc.i686 xmlstarlet graphviz mingw32 gtk2.i686 xorg-x11-server-Xvfb redhat-lsb xmlstarlet expect -y && yum clean all 

# Add a script for custom skeletton
RUN echo 'PATH=$PATH:$HOME/bin:/opt/jdk17/bin' >> /etc/profile.d/user_bin_dir.sh && echo 'WAS7RUNTIME=/var/data/jenkins/buildtools/was70' >> /etc/profile.d/user_bin_dir.sh && echo 'WAS85RUNTIME=/var/data/jenkins/buildtools/was85' >> /etc/profile.d/user_bin_dir.sh

# Create Data directory structure and add user jenkins to the image
RUN mkdir -p ${datadir} && adduser jenkins --home ${jenkinshome} && mkdir -p ${jenkinshome}/{bin,m2,buildtools,.ssh}

# Create .m2 repository and download newest settings.xml
RUN cd ${jenkinshome} && ln -s m2 .m2 && cd ${jenkinshome}/m2 && wget --quiet https://svn.sbb.ch/svn/mwe/wzu/ci-admin-files/settings.xml --user=${user} --password=${password} --no-check-certificate

# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

# Add authorized keys
RUN wget --quiet ${filerurl}/jenkins-slave-authorized_keys -O ${jenkinshome}/.ssh/authorized_keys && chown -R jenkins:jenkins ${jenkinshome}/.ssh && chmod 640 ${jenkinshome}/.ssh/authorized_keys

# Get android sdk
RUN cd ${jenkinshome}/buildtools/android-sdk-linux && wget --quiet ${filerurl}/android-sdk-update.sh -O android-sdk-update.sh && chmod +x ./android-sdk-update.sh && su - jenkins -c "export ANDROID_HOME=${jenkinshome}/buildtools/android-sdk-linux && ${jenkinshome}/buildtools/android-sdk-linux/android-sdk-update.sh"

# Download JDK 1.7 as jenkins runtime
RUN wget --quiet ${filerurl}/jdk17.tar.gz -O /tmp/jdk17.tar.gz && cd /opt/ && tar xfz /tmp/jdk17.tar.gz && rm -f /tmp/jdk17.tar.gz && ln -s /opt/jdk1.7* /opt/jdk17 && /opt/jdk17/bin/java -version

# Download Maven 3.0
RUN wget --quiet "http://mirror.switch.ch/mirror/apache/dist/maven/maven-3/${mvn30version}/binaries/apache-maven-${mvn30version}-bin.tar.gz" -O /tmp/apache-maven-${mvn30version}-bin.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/apache-maven-${mvn30version}-bin.tar.gz && rm -f `find ${jenkinshome}/buildtools/apache-maven*/conf/settings.xml` && rm -f /tmp/apache-maven-${mvn30version}-bin.tar.gz

# Download Maven 3.1
RUN wget --quiet "http://mirror.switch.ch/mirror/apache/dist/maven/maven-3/${mvn31version}/binaries/apache-maven-${mvn31version}-bin.tar.gz" -O /tmp/apache-maven-${mvn31version}-bin.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/apache-maven-${mvn31version}-bin.tar.gz && rm -f `find ${jenkinshome}/buildtools/apache-maven*/conf/settings.xml` && rm -f /tmp/apache-maven-${mvn31version}-bin.tar.gz

# Download Maven 3.2
RUN wget --quiet "http://mirror.switch.ch/mirror/apache/dist/maven/maven-3/${mvn32version}/binaries/apache-maven-${mvn32version}-bin.tar.gz" -O /tmp/apache-maven-${mvn32version}-bin.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/apache-maven-${mvn32version}-bin.tar.gz && rm -f `find ${jenkinshome}/buildtools/apache-maven*/conf/settings.xml` && rm -f /tmp/apache-maven-${mvn32version}-bin.tar.gz

# Get Oracle 6 JDK
RUN wget --quiet ${filerurl}/oracle-jdk-6.tar.gz -O /tmp/oracle-jdk-6.tar.gz  && cd ${jenkinshome}/buildtools && tar xfz /tmp/oracle-jdk-6.tar.gz && rm -f /tmp/oracle-jdk-6.tar.gz && ln -s jdk1.6* oracle-jdk-6

# Get Oracle 7 JDK
RUN wget --quiet ${filerurl}/oracle-jdk-7.tar.gz -O /tmp/oracle-jdk-7.tar.gz  && cd ${jenkinshome}/buildtools && tar xfz /tmp/oracle-jdk-7.tar.gz && rm -f /tmp/oracle-jdk-7.tar.gz && ln -s jdk1.7* oracle-jdk-7

# Get Oracle 8 JDK
RUN wget --quiet ${filerurl}/oracle-jdk-8.tar.gz -O /tmp/oracle-jdk-8.tar.gz  && cd ${jenkinshome}/buildtools && tar xfz /tmp/oracle-jdk-8.tar.gz && rm -f /tmp/oracle-jdk-8.tar.gz && ln -s jdk1.8* oracle-jdk-8

# Get WAS 70 JDK
RUN wget --quiet ${filerurl}/was70-jdk.tar.gz -O /tmp/was70-jdk.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/was70-jdk.tar.gz && ln -s jdk-ibm-1.6* ibm-jdk-was70 && rm -f /tmp/was70-jdk.tar.gz

# Get WAS 85 JDK
RUN wget --quiet ${filerurl}/was85-jdk.tar.gz -O /tmp/was85-jdk.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/was85-jdk.tar.gz && ln -s jdk-ibm-1.7* ibm-jdk-was85 && rm -f /tmp/was85-jdk.tar.gz

# Download the swarm client
RUN wget --quiet "http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/${swarmversion}/swarm-client-${swarmversion}-jar-with-dependencies.jar" -O ${jenkinshome}/swarm-client.jar

# Legacy stuff
RUN cd ${jenkinshome} && ln -s buildtools/ build-binaries && cd build-binaries && ln -s apache-maven-${mvn30version} apache-maven-3.0.4 && ln -s oracle-jdk-6 jdk-oracle-1.6.0.30 && ln -s oracle-jdk-7 jdk-oracle-1.7.0.3 && ln -s oracle-jdk-7 1.7.0.2 && ln -s oracle-jdk-8 jdk-oracle-1.8.0.5-64b && ln -s jdk-ibm-1.7.0.5 jdk-ibm-1.7.0.2

# Chown ${jenkinshome} to jenkins
RUN chown -R jenkins:jenkins ${jenkinshome}

# Standard SSH port
EXPOSE 22

# Start sshd daemon on container start
CMD ["server", "sshd", "start"]

# Start Slave
CMD su - jenkins -c "/opt/jdk17/bin/java -jar ${jenkinshome}/swarm-client.jar -description 'JEE Slave' -executors ${executors} -fsroot ${jenkinshome} -master ${master} -username ${user} -password ${password} -mode exclusive -labels swarm"
