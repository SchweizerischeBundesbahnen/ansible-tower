# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM centos:centos6
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

#Environment variables
ENV mvnversion 3.2.3
ENV swarmversion 1.16
ENV master http://ci-t.sbb.ch
ENV user fsvctip
ENV password sommer11

# Install a basic SSH server and some nice admin tools
RUN yum install -q openssh-server vim wget tar subversion git glibc.i686 libgcc.i686 xmlstarlet graphviz mingw32 gtk2.i686 xorg-x11-server-Xvfb redhat-lsb -y && yum clean all 

# Add a script for custom skeletton
RUN echo 'PATH=$PATH:$HOME/bin:/opt/jdk17/bin' > /etc/profile.d/user_bin_dir.sh

# Create Data directory structure and add user jenkins to the image
RUN mkdir -p /var/data && adduser jenkins --home /var/data/jenkins && mkdir -p /var/data/jenkins/{bin,m2,buildtools,.ssh}

# Create .m2 repository and download newest settings.xml
RUN cd /var/data/jenkins && ln -s m2 .m2 && cd /var/data/jenkins/m2 && wget --quiet https://svn.sbb.ch/svn/mwe/wzu/ci-admin-files/settings.xml --user=${user} --password=${password} --no-check-certificate

# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

# Add authorized keys
RUN wget --quiet http://wzufiler.sbb.ch/jenkins-slave-authorized_keys -O /var/data/jenkins/.ssh/authorized_keys && chown -R jenkins:jenkins /var/data/jenkins/.ssh && chmod 640 /var/data/jenkins/.ssh/authorized_keys

# Download JDK 1.7 as jenkins runtime
RUN wget --quiet http://wzufiler.sbb.ch/jdk17.tar.gz -O /tmp/jdk17.tar.gz && cd /opt/ && tar xfz /tmp/jdk17.tar.gz && rm -f /tmp/jdk17.tar.gz && ln -s /opt/jdk1.7* /opt/jdk17 && /opt/jdk17/bin/java -version

# Download Maven 3
RUN wget --quiet http://mirror.switch.ch/mirror/apache/dist/maven/maven-3/${mvnversion}/binaries/apache-maven-${mvnversion}-bin.tar.gz -O /tmp/apache-maven-${mvnversion}-bin.tar.gz && cd /var/data/jenkins/buildtools && tar xfz /tmp/apache-maven-${mvnversion}-bin.tar.gz && rm -f `find /var/data/jenkins/buildtools/apache-maven*/conf/settings.xml` && rm -f /tmp/apache-maven-${mvnversion}-bin.tar.gz

# Download and extract WAS 70 and create profile
RUN wget --quiet http://wzufiler.sbb.ch/was70.tar.gz -O /tmp/was70.tar.gz && cd /var/data/jenkins/buildtools && tar xfz /tmp/was70.tar.gz && rm -f /tmp/was70.tar.gz && /var/data/jenkins/buildtools/was70/bin/manageprofiles.sh -create -profileName default -nodeName default -hostName localhost

# Download and extract WAS 85 
RUN wget --quiet http://wzufiler.sbb.ch/was85.tar.gz -O /tmp/was85.tar.gz && cd /var/data/jenkins/buildtools && tar xfz /tmp/was85.tar.gz && rm -f /tmp/was85.tar.gz && /var/data/jenkins/buildtools/was85/bin/manageprofiles.sh -create -profileName default -nodeName default -hostName localhost

# Get Oracle 6 JDK
RUN wget --quiet http://wzufiler.sbb.ch/oracle-jdk-6.tar.gz -O /tmp/oracle-jdk-6.tar.gz  && cd /var/data/jenkins/buildtools && tar xfz /tmp/oracle-jdk-6.tar.gz && rm -f /tmp/oracle-jdk-6.tar.gz && ln -s jdk1.6* oracle-jdk-6

# Get Oracle 7 JDK
RUN wget --quiet http://wzufiler.sbb.ch/oracle-jdk-7.tar.gz -O /tmp/oracle-jdk-7.tar.gz  && cd /var/data/jenkins/buildtools && tar xfz /tmp/oracle-jdk-7.tar.gz && rm -f /tmp/oracle-jdk-7.tar.gz && ln -s jdk1.7* oracle-jdk-7

# Get Oracle 8 JDK
RUN wget --quiet http://wzufiler.sbb.ch/oracle-jdk-8.tar.gz -O /tmp/oracle-jdk-8.tar.gz  && cd /var/data/jenkins/buildtools && tar xfz /tmp/oracle-jdk-8.tar.gz && rm -f /tmp/oracle-jdk-8.tar.gz && ln -s jdk1.8* oracle-jdk-8

# Get WAS 70 JDK
RUN wget --quiet http://wzufiler.sbb.ch/was70-jdk.tar.gz -O /tmp/was70-jdk.tar.gz && cd /var/data/jenkins/buildtools && tar xfz /tmp/was70-jdk.tar.gz && ln -s jdk-ibm-1.6* ibm-jdk-was70 && rm -f /tmp/was70-jdk.tar.gz

# Get WAS 85 JDK
RUN wget --quiet http://wzufiler.sbb.ch/was85-jdk.tar.gz -O /tmp/was85-jdk.tar.gz && cd /var/data/jenkins/buildtools && tar xfz /tmp/was85-jdk.tar.gz && ln -s jdk-ibm-1.7* ibm-jdk-was85 && rm -f /tmp/was85-jdk.tar.gz

# Download the swarm client
RUN wget --quiet "http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/${swarmversion}/swarm-client-${swarmversion}-jar-with-dependencies.jar" -O /var/data/jenkins/swarm-client.jar

# Legacy stuff
RUN cd /var/data/jenkins && ln -s buildtools/ build-binaries && cd build-binaries && ln -s apache-maven-${mvnversion} apache-maven-3.0.4 && ln -s apache-maven-${mvnversion} apache-maven-3.1.1 && ln -s oracle-jdk-6 jdk-oracle-1.6.0.30 && ln -s oracle-jdk-7 jdk-oracle-1.7.0.3 && ln -s oracle-jdk-7 1.7.0.2 && ln -s oracle-jdk-8 jdk-oracle-1.8.0.5-64b

# Chown /var/data/jenkins to jenkins
RUN chown -R jenkins:jenkins /var/data/jenkins

# Standard SSH port
EXPOSE 22

# Start sshd daemon on container start
CMD ["server", "sshd", "start"]

# Start Slave
CMD su - jenkins -c "/opt/jdk17/bin/java -jar /var/data/jenkins/swarm-client.jar -description jee -executors 2 -fsroot /var/data/jenkins -master ${master} -username ${user} -password ${password}"
