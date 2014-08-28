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
ENV jenkinsjnlpurl https://ci.sbb.ch/computer/Docker2%20auf%20i38115/slave-agent.jnlp
ENV jenkinssecret 041424174cf22ca698cb969a413b285d9a8c729d4046147027565bb85d19f62e

# Install epel repo
RUN yum install -q http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -y && yum update -q -y && yum clean all

# Install a basic SSH server and some nice admin tools
RUN yum install -q openssh-server vim wget tar subversion git glibc.i686 libgcc.i686 xmlstarlet graphviz mingw32 gtk2.i686 xorg-x11-server-Xvfb redhat-lsb xmlstarlet expect -y && yum clean all 

# Create Data directory structure and add user jenkins to the image
RUN mkdir -p ${datadir} && adduser ${appuser} -U -u 10${portoffset} --home ${jenkinshome} && mkdir -p ${jenkinshome}/{bin,m2,buildtools,.ssh} 

# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

# Get jenkins-prepare-script and run it
RUN wget --quiet ${filerurl}/prepare-jenkins-slave-jee.sh -O /tmp/prepare-jenkins-slave-jee.sh && chmod +x /tmp/prepare-jenkins-slave-jee.sh && /bin/bash /tmp/prepare-jenkins-slave-jee.sh && rm -f /tmp/prepare-jenkins-slave-jee.sh

# Legacy stuff
RUN cd ${jenkinshome} && ln -s m2 .m2 && ln -s buildtools/ build-binaries && cd build-binaries && ln -s apache-maven-${mvn30version} apache-maven-3.0.4 && ln -s oracle-jdk-6 jdk-oracle-1.6.0.30 && ln -s oracle-jdk-6-32b jdk-oracle-1.6.0.31-32b && ln -s oracle-jdk-6 jdk-oracle-1.6.0.31 && ln -s oracle-jdk-7 jdk-oracle-1.7.0.3 && ln -s oracle-jdk-7-32b jdk-oracle-1.7.0.3-32b && ln -s oracle-jdk-7 1.7.0.2 && ln -s oracle-jdk-8 jdk-oracle-1.8.0.5-64b && ln -s jdk-ibm-1.7.0.5 jdk-ibm-1.7.0.2 && ln -s was85 base_v85 && ln -s was70 base_v70 && ln -s oracle-jdk-7 jdk-oracle-1.7.0.2

# Chown ${jenkinshome} to jenkins
RUN chown -R jenkins:jenkins ${jenkinshome}

# Change timezone to Europe/Zurich
RUN ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

# Create environment file
RUN echo 'export PATH=$PATH:$HOME/bin:/opt/jdk17/bin WAS7RUNTIME=/var/data/jenkins/buildtools/was70 WAS85RUNTIME=/var/data/jenkins/buildtools/was85' >> ${jenkinshome}/env.sh

# Add environment variables to run on start
RUN echo "wget --quiet ${settingsxmlurl} --user ${svnuser} --password ${svnpassword} --no-check-certificate -O ${jenkinshome}/m2/settings.xml" >> /root/run.sh && echo "wget --quiet https://ci.sbb.ch/jnlpJars/slave.jar -O ${jenkinshome}/slave.jar" >> /root/run.sh && echo 'su - jenkins -c "source ${jenkinshome}/env.sh && ulimit -u 20000 && ulimit -n 30000 && /opt/jdk17/bin/java -jar ${jenkinshome}/slave.jar -jnlpUrl ${jenkinsjnlpurl} -secret ${jenkinssecret}"' >> /root/run.sh && chmod +x /root/run.sh

# Start Slave
CMD /root/run.sh 
