# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/base7
MAINTAINER Igor Masen <igor.masen@sbb.ch>

#Environment variables
ENV mvn30version 3.0.5
ENV mvn31version 3.1.1
ENV mvn32version 3.2.5
ENV mvn33version 3.3.3
ENV antversion 1.9.4
ENV swarmversion 1.22
ENV appuser jenkins
ENV portoffset 91
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
ENV slavename $labels
ENV externalport 12345 
ENV host example.sbb.ch 
ENV keystore keystore-20150722

# Install dev tools
RUN yum install -q python-lxml git subversion glibc.i686 libgcc.i686 xmlstarlet graphviz mingw32 mingw32-nsis gtk2.i686 xorg-x11-server-Xvfb redhat-lsb xmlstarlet expect sqlplus libaio -y && yum clean all -q 

# Create Data directory structure and add user jenkins to the image
RUN mkdir -p ${datadir} && adduser ${appuser} -U -u 10${portoffset} --home ${jenkinshome} && mkdir -p ${jenkinshome}/{bin,m2,buildtools,.ssh,temp} && mkdir -p ${jenkinshome}/m2/repository ${jenkinshome}/workspace && echo "${appuser}:${appuser}" | chpasswd

# Adding Jenkins SSH Keys for access to Stash: https://issues.sbb.ch/browse/MWESERVICE-6123 
COPY configs/id_rsa* ${jenkinshome}/.ssh/
RUN chown -R ${appuser}:${appuser} ${jenkinshome}/.ssh && chmod 700 ${jenkinshome}/.ssh && chmod 600 ${jenkinshome}/.ssh/* 

# Download Ant 1
RUN cd ${jenkinshome}/buildtools \
	&& wget -qO- ${filerurl}/apache-ant-1.8.tar.gz | tar xfz - \
	&& ln -s apache-ant-1.8* apache-ant-1.8 

# Download Maven 3.0
RUN cd ${jenkinshome}/buildtools \
	&& wget -qO- "http://mirror.switch.ch/mirror/apache/dist/maven/maven-3/${mvn30version}/binaries/apache-maven-${mvn30version}-bin.tar.gz" | tar xfz - \
	&& rm -f `find ${jenkinshome}/buildtools/apache-maven*/conf/settings.xml` 

# Download Maven 3.1
RUN cd ${jenkinshome}/buildtools \
	&& wget -qO- "http://mirror.switch.ch/mirror/apache/dist/maven/maven-3/${mvn31version}/binaries/apache-maven-${mvn31version}-bin.tar.gz" | tar xfz - \
	&& rm -f `find ${jenkinshome}/buildtools/apache-maven*/conf/settings.xml` 

# Download Maven 3.2
RUN cd ${jenkinshome}/buildtools \
	&& wget -qO- "http://mirror.switch.ch/mirror/apache/dist/maven/maven-3/${mvn32version}/binaries/apache-maven-${mvn32version}-bin.tar.gz" | tar xfz - \
	&& rm -f `find ${jenkinshome}/buildtools/apache-maven*/conf/settings.xml` 

# Download Maven 3.3
RUN cd ${jenkinshome}/buildtools \
        && wget -qO- "http://mirror.switch.ch/mirror/apache/dist/maven/maven-3/${mvn33version}/binaries/apache-maven-${mvn33version}-bin.tar.gz" | tar xfz - \
        && rm -f `find ${jenkinshome}/buildtools/apache-maven*/conf/settings.xml`

# Get Oracle 6 32 Bit JDK
RUN wget --quiet ${filerurl}/oracle-jdk-6-32b.tar.gz -O /tmp/oracle-jdk-6-32b.tar.gz  \
	&& cd ${jenkinshome}/buildtools \
	&& tar xfz /tmp/oracle-jdk-6-32b.tar.gz \
	&& rm -f /tmp/oracle-jdk-6-32b.tar.gz \
	&& ln -s jdk1.6*32b oracle-jdk-6-32b

# Get Oracle 7 32 Bit JDK
RUN wget --quiet ${filerurl}/oracle-jdk-7-32b.tar.gz -O /tmp/oracle-jdk-7-32b.tar.gz \
	&& cd ${jenkinshome}/buildtools \
	&& tar xfz /tmp/oracle-jdk-7-32b.tar.gz \
	&& rm -f /tmp/oracle-jdk-7-32b.tar.gz \
	&& ln -s jdk1.7*32b oracle-jdk-7-32b

# Get Oracle 8 JDK
RUN wget --quiet ${filerurl}/oracle-jdk-8-32b.tar.gz -O /tmp/oracle-jdk-8-32b.tar.gz \
	&& cd ${jenkinshome}/buildtools \
	&& tar xfz /tmp/oracle-jdk-8-32b.tar.gz \
	&& rm -f /tmp/oracle-jdk-8-32b.tar.gz \
	&& ln -s jdk1.8*32b oracle-jdk-8-32b

# Get Oracle 6 JDK
RUN wget --quiet ${filerurl}/oracle-jdk-6.tar.gz -O /tmp/oracle-jdk-6.tar.gz \
	&& cd ${jenkinshome}/buildtools \
	&& tar xfz /tmp/oracle-jdk-6.tar.gz \
	&& rm -f /tmp/oracle-jdk-6.tar.gz \
	&& ln -s `ls | grep jdk1.6.0 | grep -v 32b` oracle-jdk-6

# Get Oracle 7 JDK
RUN wget --quiet ${filerurl}/oracle-jdk-7.tar.gz -O /tmp/oracle-jdk-7.tar.gz \
	&& cd ${jenkinshome}/buildtools \
	&& tar xfz /tmp/oracle-jdk-7.tar.gz \
	&& rm -f /tmp/oracle-jdk-7.tar.gz \
	&& ln -s `ls | grep jdk1.7.0 | grep -v 32b` oracle-jdk-7

# Get Oracle 8 JDK
RUN wget --quiet ${filerurl}/oracle-jdk-8.tar.gz -O /tmp/oracle-jdk-8.tar.gz \
	&& cd ${jenkinshome}/buildtools \
	&& tar xfz /tmp/oracle-jdk-8.tar.gz \
	&& rm -f /tmp/oracle-jdk-8.tar.gz \
	&& ln -s `ls | grep jdk1.8.0 | grep -v 32b` oracle-jdk-8

# Install IBM JDK 1.6
RUN cd ${jenkinshome}/buildtools \
        && wget -qO- ${filerurl}/was70-jdk.tar.gz | tar xfz - \
        && ln -s jdk-ibm-1.6* ibm-jdk-was70 \
	&& ${jenkinshome}/buildtools/ibm-jdk-was70/bin/java -version

# Install IBM JDK 1.7
RUN cd ${jenkinshome}/buildtools \
        && wget -qO- ${filerurl}/was85-jdk.tar.gz | tar xfz - \
        && ln -s jdk-ibm-1.7* ibm-jdk-was85 \
	&& ${jenkinshome}/buildtools/ibm-jdk-was85/bin/java -version

# Legacy stuff
RUN cd ${jenkinshome}/buildtools \
	&& ln -s ibm-jdk-was85 jdk-ibm-1.7.0.2 \
	&& ln -s was85 base_v85 \
	&& ln -s was70 base_v70

# Modify IBM JDK security settings
COPY configs/java.security.was85 ${jenkinshome}/buildtools/ibm-jdk-was85/jre/lib/security/java.security
COPY configs/java.security.was7 ${jenkinshome}/buildtools/ibm-jdk-was70/jre/lib/security/java.security

# Download the swarm client
RUN wget --quiet "http://repo.sbb.ch/content/repositories/mirror/org/jenkins-ci/plugins/swarm-client/${swarmversion}/swarm-client-${swarmversion}-jar-with-dependencies.jar" -O ${jenkinshome}/swarm-client.jar

# Install sqlplus
RUN wget -qnc http://wzufiler.sbb.ch/oracle/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm \
        && wget -qnc http://wzufiler.sbb.ch/oracle/oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm \
        && rpm -ivh oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm \
        && rpm -ivh oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm \
        && echo "ORACLE_HOME=/usr/lib/oracle/12.1/client64" >> ${jenkinshome}/env.sh \
        && echo "LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib" >> ${jenkinshome}/env.sh \
        && echo "export ORACLE_HOME" >> ${jenkinshome}/env.sh \
        && echo "export LD_LIBRARY_PATH" >> ${jenkinshome}/env.sh

# Legacy stuff
RUN cd ${jenkinshome} \
	&& ln -s m2 .m2 \
	&& ln -s buildtools/ build-binaries \
	&& cd build-binaries \
	&& ln -s apache-maven-${mvn30version} apache-maven-3.0.4 \
	&& ln -s oracle-jdk-6 jdk-oracle-1.6.0.30 \
	&& ln -s oracle-jdk-6-32b jdk-oracle-1.6.0.31-32b \
	&& ln -s oracle-jdk-6 jdk-oracle-1.6.0.31 \
	&& ln -s oracle-jdk-7 jdk-oracle-1.7.0.3 \
	&& ln -s oracle-jdk-7-32b jdk-oracle-1.7.0.3-32b \
	&& ln -s oracle-jdk-7 1.7.0.2 \
	&& ln -s oracle-jdk-8 jdk-oracle-1.8.0.5-64b \
	&& ln -s oracle-jdk-7 jdk-oracle-1.7.0.2

# Create environment file
RUN echo 'export PATH=$PATH:$HOME/bin:/opt/jdk/bin:/usr/lib/oracle/12.1/client64/bin LC_ALL=en_US.UTF-8' >> ${jenkinshome}/env.sh

# Disable Hostkeychecks for ssh for enabling batch-based git clones: https://issues.sbb.ch/browse/MWESERVICE-4234, https://issues.sbb.ch/browse/MWESERVICE-5960
RUN echo -e "Host code.sbb.ch\n\tStrictHostKeyChecking no\nHost code-ext.sbb.ch\n\tStrictHostKeyChecking no\n">> ${jenkinshome}/.ssh/config && chmod 644 ${jenkinshome}/.ssh/config

# Git-Setting for Jenkins-User for Ci-based git commits: https://issues.sbb.ch/browse/WZU-3262#
RUN echo -e "[user]\n\tname = jenkins\n\temail = no-reply@sbb.ch">> ${jenkinshome}/.gitconfig && chmod 644 ${jenkinshome}/.gitconfig

# Add environment variables to run on start
RUN echo "wget --quiet ${settingsxmlurl} --user ${svnuser} --password ${svnpassword} --no-check-certificate -O ${jenkinshome}/m2/settings.xml" >> ${jenkinshome}/run.sh \
	&& wget --quiet ${filerurl}/${keystore} -O ${jenkinshome}/.keystore \
	&& chmod +x ${jenkinshome}/run.sh

# Use our ultimate keystrore in all jdks
RUN  cd ${jenkinshome}/buildtools \
	&& rm ./oracle-jdk-6-32b/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./oracle-jdk-6-32b/jre/lib/security/cacerts \
	&& rm ./jdk1.7.0_67-32b/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./jdk1.7.0_67-32b/jre/lib/security/cacerts \
	&& rm ./jdk1.8.0_51-32b/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./jdk1.8.0_51-32b/jre/lib/security/cacerts \
	&& rm ./jdk1.6.0_45/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./jdk1.6.0_45/jre/lib/security/cacerts \
	&& rm ./jdk1.7.0_67/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./jdk1.7.0_67/jre/lib/security/cacerts \
	&& rm ./jdk1.8.0_51/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./jdk1.8.0_51/jre/lib/security/cacerts \
	&& rm ./jdk-ibm-1.6.0.9/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./jdk-ibm-1.6.0.9/jre/lib/security/cacerts \
	&& rm ./jdk-ibm-1.7.0.5/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./jdk-ibm-1.7.0.5/jre/lib/security/cacerts
