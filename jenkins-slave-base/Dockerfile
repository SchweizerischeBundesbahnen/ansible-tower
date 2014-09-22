# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM centos:centos6
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

#Environment variables
ENV mvn30version 3.0.5
ENV mvn31version 3.1.1
ENV mvn32version 3.2.3
ENV antversion 1.9.4
ENV swarmversion 1.16
ENV appuser jenkins
ENV portoffset 90
ENV datadir /var/data 
ENV jenkinshome ${datadir}/jenkins
ENV master http://ci-t.sbb.ch
ENV ciuser overridethis 
ENV svnuser fsbuild 
ENV cipassword overridethis 
ENV svnpassword fsbuild2011 
ENV executors 1
ENV filerurl http://wzufiler.sbb.ch
ENV settingsxmlurl https://svn.sbb.ch/svn/mwe/wzu/ci-admin-files/settings.xml 
ENV labels swarm

# Install epel repo
RUN yum install -q http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -y && yum update -q -y && yum clean all && yum install -q openssh-server vim wget tar subversion git glibc.i686 libgcc.i686 xmlstarlet graphviz mingw32 gtk2.i686 xorg-x11-server-Xvfb redhat-lsb xmlstarlet expect unzip -y && yum clean all -q 

# Create Data directory structure and add user jenkins to the image
RUN mkdir -p ${datadir} && adduser ${appuser} -U -u 10${portoffset} --home ${jenkinshome} && mkdir -p ${jenkinshome}/{bin,m2,buildtools,.ssh} && echo "jenkins:jenkins" | chpasswd

# Download JDK 1.7 as jenkins runtime
RUN wget --quiet ${filerurl}/jdk17.tar.gz -O /tmp/jdk17.tar.gz && cd /opt/ && tar xfz /tmp/jdk17.tar.gz && rm -f /tmp/jdk17.tar.gz && ln -s /opt/jdk1.7* /opt/jdk17 && ln -s /opt/jdk17/bin/java ${jenkinshome}/bin/java && su - jenkins -c "java -version" 

# Download Ant 1
RUN wget --quiet ${filerurl}/apache-ant-1.8.tar.gz -O /tmp/apache-ant-1.8.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/apache-ant-1.8.tar.gz && ln -s apache-ant-1.8* apache-ant-1.8 && rm -f /tmp/apache-ant-1.8.tar.gz

# Download Maven 3.0
RUN wget --quiet "http://mirror.switch.ch/mirror/apache/dist/maven/maven-3/${mvn30version}/binaries/apache-maven-${mvn30version}-bin.tar.gz" -O /tmp/apache-maven-${mvn30version}-bin.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/apache-maven-${mvn30version}-bin.tar.gz && rm -f `find ${jenkinshome}/buildtools/apache-maven*/conf/settings.xml` && rm -f /tmp/apache-maven-${mvn30version}-bin.tar.gz

# Download Maven 3.1
RUN wget --quiet "http://mirror.switch.ch/mirror/apache/dist/maven/maven-3/${mvn31version}/binaries/apache-maven-${mvn31version}-bin.tar.gz" -O /tmp/apache-maven-${mvn31version}-bin.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/apache-maven-${mvn31version}-bin.tar.gz && rm -f `find ${jenkinshome}/buildtools/apache-maven*/conf/settings.xml` && rm -f /tmp/apache-maven-${mvn31version}-bin.tar.gz

# Download Maven 3.2
RUN wget --quiet "http://mirror.switch.ch/mirror/apache/dist/maven/maven-3/${mvn32version}/binaries/apache-maven-${mvn32version}-bin.tar.gz" -O /tmp/apache-maven-${mvn32version}-bin.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/apache-maven-${mvn32version}-bin.tar.gz && rm -f `find ${jenkinshome}/buildtools/apache-maven*/conf/settings.xml` && rm -f /tmp/apache-maven-${mvn32version}-bin.tar.gz

# Get Oracle 6 32 Bit JDK
RUN wget --quiet ${filerurl}/oracle-jdk-6-32b.tar.gz -O /tmp/oracle-jdk-6-32b.tar.gz  && cd ${jenkinshome}/buildtools && tar xfz /tmp/oracle-jdk-6-32b.tar.gz && rm -f /tmp/oracle-jdk-6-32b.tar.gz && ln -s jdk1.6*32b oracle-jdk-6-32b

# Get Oracle 7 32 Bit JDK
RUN wget --quiet ${filerurl}/oracle-jdk-7-32b.tar.gz -O /tmp/oracle-jdk-7-32b.tar.gz  && cd ${jenkinshome}/buildtools && tar xfz /tmp/oracle-jdk-7-32b.tar.gz && rm -f /tmp/oracle-jdk-7-32b.tar.gz && ln -s jdk1.7*32b oracle-jdk-7-32b

# Get Oracle 8 JDK
RUN wget --quiet ${filerurl}/oracle-jdk-8-32b.tar.gz -O /tmp/oracle-jdk-8-32b.tar.gz  && cd ${jenkinshome}/buildtools && tar xfz /tmp/oracle-jdk-8-32b.tar.gz && rm -f /tmp/oracle-jdk-8-32b.tar.gz && ln -s jdk1.8*32b oracle-jdk-8-32b

# Get Oracle 6 JDK
RUN wget --quiet ${filerurl}/oracle-jdk-6.tar.gz -O /tmp/oracle-jdk-6.tar.gz  && cd ${jenkinshome}/buildtools && tar xfz /tmp/oracle-jdk-6.tar.gz && rm -f /tmp/oracle-jdk-6.tar.gz && ln -s `ls | grep jdk1.6.0 | grep -v 32b` oracle-jdk-6

# Get Oracle 7 JDK
RUN wget --quiet ${filerurl}/oracle-jdk-7.tar.gz -O /tmp/oracle-jdk-7.tar.gz  && cd ${jenkinshome}/buildtools && tar xfz /tmp/oracle-jdk-7.tar.gz && rm -f /tmp/oracle-jdk-7.tar.gz && ln -s `ls | grep jdk1.7.0 | grep -v 32b` oracle-jdk-7

# Get Oracle 8 JDK
RUN wget --quiet ${filerurl}/oracle-jdk-8.tar.gz -O /tmp/oracle-jdk-8.tar.gz  && cd ${jenkinshome}/buildtools && tar xfz /tmp/oracle-jdk-8.tar.gz && rm -f /tmp/oracle-jdk-8.tar.gz && ln -s `ls | grep jdk1.8.0 | grep -v 32b` oracle-jdk-8

# Download the swarm client
RUN wget --quiet "http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/${swarmversion}/swarm-client-${swarmversion}-jar-with-dependencies.jar" -O ${jenkinshome}/swarm-client.jar

# Legacy stuff
RUN cd ${jenkinshome} && ln -s m2 .m2 && ln -s buildtools/ build-binaries && cd build-binaries && ln -s apache-maven-${mvn30version} apache-maven-3.0.4 && ln -s oracle-jdk-6 jdk-oracle-1.6.0.30 && ln -s oracle-jdk-6-32b jdk-oracle-1.6.0.31-32b && ln -s oracle-jdk-6 jdk-oracle-1.6.0.31 && ln -s oracle-jdk-7 jdk-oracle-1.7.0.3 && ln -s oracle-jdk-7-32b jdk-oracle-1.7.0.3-32b && ln -s oracle-jdk-7 1.7.0.2 && ln -s oracle-jdk-8 jdk-oracle-1.8.0.5-64b && ln -s oracle-jdk-7 jdk-oracle-1.7.0.2

# Change timezone to Europe/Zurich
RUN ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

# Create environment file
RUN echo 'export PATH=$PATH:$HOME/bin:/opt/jdk17/bin LC_ALL=en_US.UTF-8' >> ${jenkinshome}/env.sh

# Add environment variables to run on start
RUN echo "wget --quiet ${settingsxmlurl} --user ${svnuser} --password ${svnpassword} --no-check-certificate -O ${jenkinshome}/m2/settings.xml" >> ${jenkinshome}/run.sh && wget --quiet ${wzufiler}/keystore -O ${jenkinshome}/.keystore && chmod +x ${jenkinshome}/run.sh

# Chown JENKINS_HOME to jenkins
RUN chown -R jenkins:jenkins ${jenkinshome}

# Start Slave
CMD ${jenkinshome}/run.sh && su - jenkins -c "source ${jenkinshome}/env.sh && /opt/jdk17/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -username ${ciuser} -password ${cipassword} -labels ${labels}" 
