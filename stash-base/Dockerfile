FROM schweizerischebundesbahnen/base
MAINTAINER Sebastian Graf <sebastian.graf@sbb.ch>

#Environment Variables
ENV stashversion 3.4.1
ENV gitversion 1.8.5.5
ENV mysqlconnectorversion 5.1.32
ENV idoffset 120
ENV appuser stash
ENV datadir /var/data
ENV stash_home /var/data/stash
ENV PATH /usr/local/bin:/sbin:/usr/sbin:/usr/bin:/bin

#Installing toolchain necessary to compile git > 1.7.1 (shipped with rhel 6)
RUN yum install -q -y gcc openssl-devel curl-devel expat-devel perl-ExtUtils-CBuilder perl-ExtUtils-MakeMaker gettext && yum clean all -q 

# Download, make and install git because of https://answers.atlassian.com/questions/52498/stash-requires-git-1-7-6-but-rhel6-comes-with-git-1-7-1?page=1#86674
RUN cd /usr/local/src && wget --quiet https://www.kernel.org/pub/software/scm/git/git-${gitversion}.tar.gz && tar xzf git-${gitversion}.tar.gz && cd git-${gitversion} && ./configure --prefix=/usr/local --without-tcltk && make prefix=/usr/local all && make prefix=/usr/local install && rm -rf git-${gitversion}* && git --version

# Create Data directory structure and add user jira to the image
RUN mkdir -p ${datadir} && adduser ${appuser} -U -u 1${idoffset} --home ${stash_home} && mkdir -p ${stash_home}/shared

#Getting stash and setting it
RUN wget --quiet http://www.atlassian.com/software/stash/downloads/binary/atlassian-stash-${stashversion}.tar.gz -O /opt/atlassian-stash-${stashversion}.tar.gz && cd /opt && tar xfz atlassian-stash-${stashversion}.tar.gz && rm -f /opt/atlassian-stash-${stashversion}.tar.gz && ln -s /opt/atlassian-stash* /opt/stash

RUN mv /opt/stash/conf/server.xml /opt/stash/conf/server-backup.xml

# Install JDBC driver
RUN wget --quiet "http://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/${mysqlconnectorversion}/mysql-connector-java-${mysqlconnectorversion}.jar" -O /opt/stash/lib/mysql-connector-java-${mysqlconnectorversion}-bin.jar

#Setting Java Home and Stash Home in /opt/stash/bin/setenv.sh
RUN sed -i 's,#!/usr/bin/env bash,#!/usr/bin/env bash\n#\n#Customizing for SBB\n#\n# setting JAVA_HOME\nJAVA_HOME="/opt/jdk",g' /opt/stash/bin/setenv.sh && sed -i 's,#STASH_HOME="",STASH_HOME="/var/data/stash",g' /opt/stash/bin/setenv.sh

#According to https://confluence.atlassian.com/x/Fh6_Eg , some folders must be writable
RUN chown -R ${appuser}:${appuser} /opt/stash/logs /opt/stash/work /opt/stash/temp

#Exposing Port to make Stash accessible
EXPOSE 8120
EXPOSE 9120

# install script for stash
COPY configs/stash.ini /etc/supervisor/conf.d/

# supervisor can not use env variables
RUN sed -ri "s/APP_USER/${appuser}/g" /etc/supervisor/conf.d/stash.ini
