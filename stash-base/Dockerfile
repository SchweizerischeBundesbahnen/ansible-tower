FROM schweizerischebundesbahnen/atlassian-base
MAINTAINER Sebastian Graf <sebastian.graf@sbb.ch>

#Environment Variables
ENV stashversion 3.4.1
ENV mysqlconnectorversion 5.1.32
ENV appname stash
ENV stash_home /var/data/atlassian-base

#Installing git and wget
RUN yum install -q git-core -y && yum clean all

#Making directory for volumes
RUN mkdir -p $stash_home/shared

#Getting stash and setting it
RUN wget --quiet http://www.atlassian.com/software/stash/downloads/binary/atlassian-stash-${stashversion}.tar.gz -O /opt/atlassian-stash-${stashversion}.tar.gz && cd /opt && tar xfz atlassian-stash-${stashversion}.tar.gz && rm -f /opt/atlassian-stash-${stashversion}.tar.gz && ln -s /opt/atlassian-stash* /opt/stash

# Set Timezone to zurich
RUN ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

# backing up server.xml
RUN mv /opt/stash/conf/server.xml /opt/stash/conf/server-backup.xml

# Install JDBC driver
RUN wget --quiet "http://repo.sbb.ch/service/local/artifact/maven/redirect?r=proxy.external.nexus-ext-cache.releases&g=mysql&a=mysql-connector-java&v=${mysqlconnectorversion}&e=jar" -O /opt/stash/lib/mysql-connector-java-${mysqlconnectorversion}-bin.jar

#Setting Java Home and Stash Home in /opt/stash/bin/setenv.sh
RUN sed -i 's,#!/usr/bin/env bash,#!/usr/bin/env bash\n#\n#Customizing for SBB\n#\n# setting JAVA_HOME\nJAVA_HOME="/opt/jdk",g' /opt/stash/bin/setenv.sh && sed -i 's,#STASH_HOME="",STASH_HOME="/var/data/atlassian-base",g' /opt/stash/bin/setenv.sh


# Adding run user
RUN adduser $appname
EXPOSE 8090
# RUN chown -R $appname:$appname $stash_home

# install script for stash
COPY configs/stash.ini /etc/supervisor/conf.d/

# supervisor can not use env variables
RUN sed -ri "s/APP_USER/${appname}/g" /etc/supervisor/conf.d/stash.ini

#Linking logs and repositories in container
VOLUME ${stash_home}/log
VOLUME ${stash_home}/logs
VOLUME ${stash_home}/shared/data

WORKDIR /opt/stash