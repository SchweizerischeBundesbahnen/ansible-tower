# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM registry.sbb.ch/kd_wzu/base7
MAINTAINER Igor Masen <igor.masen@sbb.ch>

# Environment variables
ENV mvn30version 3.0.5
ENV mvn31version 3.1.1
ENV mvn32version 3.2.5
ENV mvn33version 3.3.9
ENV swarmversion 2.1
ENV appuser jenkins
ENV portoffset 91
ENV datadir /var/data
ENV jenkinshome ${datadir}/jenkins
ENV master http://ci-t.sbb.ch
ENV ciuser overridethis
ENV cipassword overridethis
ENV executors 1
ENV settingsxmlurl ${filerurl}/ci-admin-files/settings.xml
ENV labels "swarm was85 java nodejs"
ENV slavename swarm
ENV externalport 12345
ENV host example.sbb.ch
ENV orajdk632bitfile oracle-jdk-6-32b.tar.gz
ENV orajdk664bitfile oracle-jdk-6.tar.gz
ENV orajdk732bitfile jdk-7u80-linux-i586.tar.gz
ENV orajdk764bitfile jdk-7u80-linux-x64.tar.gz
ENV orajdk832bitfile jdk-8u92-linux-i586.tar.gz
ENV orajdk864bitfile jdk-8u92-linux-x64.tar.gz
ENV was8version "8.5-OM08"
ENV nodejs_version "v5.9.0"
ENV installer_url "https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh"

# Install dev tools
RUN yum install -q ansible python-lxml glibc.i686 libgcc.i686 xmlstarlet graphviz mingw32 mingw32-nsis gtk2.i686 xorg-x11-server-Xvfb redhat-lsb xmlstarlet expect libaio perl-XML-Twig python-pip rpm-build npm rubygems -y && yum clean all -q


# Create Data directory structure and add user jenkins to the image
RUN mkdir -p ${datadir} && adduser ${appuser} -U -u 10${portoffset} --home ${jenkinshome} && mkdir -p ${jenkinshome}/{bin,m2,buildtools,.ssh,temp,_scripts} && mkdir -p ${jenkinshome}/m2/repository ${jenkinshome}/workspace && mkdir -p ${jenkinshome}/.hello2morrow/SonargraphArchitect && echo "${appuser}:${appuser}" | chpasswd

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

# Create symlink for m2
RUN cd ${jenkinshome} \
	&& ln -s m2 .m2

# Create folders for different jdk architecture
RUN mkdir -p ${jenkinshome}/buildtools/{jdk32bit,jdk64bit}

# Get Oracle 6 32 Bit JDK
RUN wget --quiet --no-check-certificate ${filerurl}/jdk/${orajdk632bitfile} -O /tmp/${orajdk632bitfile}  \
	&& cd ${jenkinshome}/buildtools/jdk32bit \
	&& tar xfz /tmp/${orajdk632bitfile} \
	&& rm -f /tmp/${orajdk632bitfile} \
	&& cd .. && ln -s jdk32bit/jdk1.6* oracle-jdk-6-32b \
	&& 	${jenkinshome}/buildtools/oracle-jdk-6-32b/bin/java -version

# Get Oracle 7 32 Bit JDK
RUN wget --quiet --no-check-certificate ${filerurl}/jdk/${orajdk732bitfile} -O /tmp/${orajdk732bitfile} \
	&& cd ${jenkinshome}/buildtools/jdk32bit \
	&& tar xfz /tmp/${orajdk732bitfile} \
	&& rm -f /tmp/${orajdk732bitfile} \
	&& cd .. && ln -s jdk32bit/jdk1.7* oracle-jdk-7-32b \
	&& 	${jenkinshome}/buildtools/oracle-jdk-7-32b/bin/java -version

# Get Oracle 8 JDK
RUN wget --quiet --no-check-certificate ${filerurl}/jdk/${orajdk832bitfile} -O /tmp/${orajdk832bitfile} \
	&& cd ${jenkinshome}/buildtools/jdk32bit \
	&& tar xfz /tmp/${orajdk832bitfile} \
	&& rm -f /tmp/${orajdk832bitfile} \
	&& cd .. && ln -s jdk32bit/jdk1.8* oracle-jdk-8-32b \
	&& 	${jenkinshome}/buildtools/oracle-jdk-8-32b/bin/java -version

# Get Oracle 6 JDK
RUN wget --quiet --no-check-certificate ${filerurl}/jdk/${orajdk664bitfile} -O /tmp/${orajdk664bitfile} \
	&& cd ${jenkinshome}/buildtools/jdk64bit \
	&& tar xfz /tmp/${orajdk664bitfile} \
	&& rm -f /tmp/${orajdk664bitfile} \
	&& cd .. && ln -s jdk64bit/jdk1.6* oracle-jdk-6 \
	&& 	${jenkinshome}/buildtools/oracle-jdk-6/bin/java -version

# Get Oracle 7 JDK
RUN wget --quiet --no-check-certificate ${filerurl}/jdk/${orajdk764bitfile} -O /tmp/${orajdk764bitfile} \
	&& cd ${jenkinshome}/buildtools/jdk64bit \
	&& tar xfz /tmp/${orajdk764bitfile} \
	&& rm -f /tmp/${orajdk764bitfile} \
	&& cd .. && ln -s jdk64bit/jdk1.7* oracle-jdk-7 \
	&& 	${jenkinshome}/buildtools/oracle-jdk-7/bin/java -version

# Get Oracle 8 JDK
RUN wget --quiet --no-check-certificate ${filerurl}/jdk/${orajdk864bitfile} -O /tmp/${orajdk864bitfile} \
	&& cd ${jenkinshome}/buildtools/jdk64bit \
	&& tar xfz /tmp/${orajdk864bitfile} \
	&& rm -f /tmp/${orajdk864bitfile} \
	&& cd .. && ln -s jdk64bit/jdk1.8* oracle-jdk-8 \
	&& 	${jenkinshome}/buildtools/oracle-jdk-8/bin/java -version

# Download the swarm client
RUN wget --quiet "http://repo.sbb.ch/content/repositories/mirror/org/jenkins-ci/plugins/swarm-client/${swarmversion}/swarm-client-${swarmversion}-jar-with-dependencies.jar" -O ${jenkinshome}/swarm-client.jar

# Install sqlplus
RUN wget -q ${filerurl}/oracle/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm \
        && wget -q ${filerurl}/oracle/oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm \
        && rpm -ivh oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm \
        && rpm -ivh oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm \
        && echo "export ORACLE_HOME=/usr/lib/oracle/12.1/client64" >> ${jenkinshome}/env.sh \
        && echo "export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib" >> ${jenkinshome}/env.sh \
		&& rm -fr oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm \
		&& rm -fr oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm

# Create environment file
RUN echo 'export PATH=$PATH:$HOME/bin:/opt/jdk/bin:/usr/lib/oracle/12.1/client64/bin LC_ALL=en_US.UTF-8' >> ${jenkinshome}/env.sh

# Disable Hostkeychecks for ssh for enabling batch-based git clones: https://issues.sbb.ch/browse/MWESERVICE-4234, https://issues.sbb.ch/browse/MWESERVICE-5960,https://issues.sbb.ch/browse/MWESERVICE-9566
RUN echo -e "Host code.sbb.ch\n\tStrictHostKeyChecking no\nHost code-ext.sbb.ch\n\tStrictHostKeyChecking no\nHost code-i.sbb.ch\n\tStrictHostKeyChecking no\nHost code-ext-i.sbb.ch\n\tStrictHostKeyChecking no\nHost code-t.sbb.ch\n\tStrictHostKeyChecking no\nHost code-ext-t.sbb.ch\n\tStrictHostKeyChecking no\nHost github.com\n\tStrictHostKeyChecking no\n">> ${jenkinshome}/.ssh/config && chmod 644 ${jenkinshome}/.ssh/config

# Git-Setting for Jenkins-User for Ci-based git commits: https://issues.sbb.ch/browse/WZU-3262#
RUN echo -e "[user]\n\tname = jenkins\n\temail = no-reply@sbb.ch">> ${jenkinshome}/.gitconfig && chmod 644 ${jenkinshome}/.gitconfig

# Add environment variables to run on start
RUN echo "wget --quiet ${settingsxmlurl} --user ${fileruser} --password ${filerpassword} --no-check-certificate -O ${jenkinshome}/m2/settings.xml" >> ${jenkinshome}/run.sh \
	&& wget --quiet ${filerurl}/${keystore} -O ${jenkinshome}/.keystore \
	&& chmod +x ${jenkinshome}/run.sh

# Use our ultimate keystrore in all jdks
RUN  cd ${jenkinshome}/buildtools \
	&& rm ./oracle-jdk-6-32b/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./oracle-jdk-6-32b/jre/lib/security/cacerts \
	&& rm ./oracle-jdk-7-32b/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./oracle-jdk-7-32b/jre/lib/security/cacerts \
	&& rm ./oracle-jdk-8-32b/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./oracle-jdk-8-32b/jre/lib/security/cacerts \
	&& rm ./oracle-jdk-6/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./oracle-jdk-6/jre/lib/security/cacerts \
	&& rm ./oracle-jdk-7/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./oracle-jdk-7/jre/lib/security/cacerts \
	&& rm ./oracle-jdk-8/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./oracle-jdk-8/jre/lib/security/cacerts

# Add download settings xml script
COPY configs/download_settingsxml.sh ${jenkinshome}/_scripts/download_settingsxml.sh

# Install ansible-tower-cli (@see https://github.com/ansible/tower-cli)
RUN pip install ansible-tower-cli

# Install oc-cli (see https://issues.sbb.ch/browse/CLOUD-421)
RUN wget -qO- "http://repo.sbb.ch/service/local/artifact/maven/redirect?r=mirror&g=com.openshift&a=oc-client&v=LATEST&e=rpm" -O oc.rpm \
    && rpm -ivh oc.rpm \
    && rm -f oc.rpm \
    && oc version

# Download and extract WAS 85 and create profile
RUN cd /opt \
        &&  wget -qO- ${filerurl}/was-${was8version}.tar.gz | tar xfz - \
        && ln -s /opt/was85 ${jenkinshome}/buildtools/was85 \
        && /bin/bash ${jenkinshome}/buildtools/was85/profiles/default/bin/versionInfo.sh \
		&& chown -R ${appuser}:${appuser} ${jenkinshome} /opt/was85*

# Link WAS JDK for Jenkins
RUN cd ${jenkinshome}/buildtools \
        && ln -s ${jenkinshome}/buildtools/was85/java_1.7_64 ibm-jdk-was85 \
		&& ${jenkinshome}/buildtools/ibm-jdk-was85/bin/java -version

# Link custom keystore
RUN  cd ${jenkinshome}/buildtools \
	&& rm ./ibm-jdk-was85/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./ibm-jdk-was85/jre/lib/security/cacerts \
	&& ls -l ./ibm-jdk-was85/jre/lib/security/cacerts

# Create environment file
RUN echo 'export WAS85RUNTIME=/var/data/jenkins/buildtools/was85' >> ${jenkinshome}/env.sh

# Modify IBM JDK security settings
COPY java.security /opt/was85/java_1.7_64/jre/lib/security/java.security

# Install nodejs
RUN curl -o- ${installer_url} | bash \
	&& source /root/.bashrc \
	&& nvm install ${nodejs_version} \
	&& nvm alias default ${nodejs_version} \
	&& cp -r /root/.nvm/versions/node/${nodejs_version}/{bin,lib,share} /usr/local \
	&& rm -f /bin/node \
	&& ln -s /usr/local/bin/node /bin/node

# Install packages for build
RUN npm install bower grunt grunt-cli gulp --silent && gem install bundle

# Add node binaries to path
RUN echo 'export PATH=$PATH:/node_modules/.bin' >> ${jenkinshome}/env.sh

# Set npm-registry to SBB proxy manually (https://issues.sbb.ch/browse/WZU-4080,https://issues.sbb.ch/browse/MWESERVICE-8786)
RUN echo 'registry = http://repo.sbb.ch/content/groups/mirror.npm' >> ${jenkinshome}/.npmrc

# Chown jenkinshome
RUN chown -R ${appuser}:${appuser} ${jenkinshome}

# Start Slave
CMD echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels \"${labels}\" -mode exclusive -noRetryAfterConnected -retry 1 -disableClientsUniqueId"
