FROM schweizerischebundesbahnen/atlassian-base
MAINTAINER Sebastian Graf <sebastian.graf@sbb.ch>

#Environment Variables
ENV stashversion 2.12.5
ENV appuser stash
ENV mysqlconnectorversion 5.1.32


RUN yum install -q git-core -y
RUN curl -Lks http://www.atlassian.com/software/stash/downloads/binary/atlassian-stash-${stashversion}.tar.gz -o /root/stash.tar.gz
RUN /usr/sbin/useradd --create-home --home-dir /opt/stash --groups atlassian --shell /bin/bash $appuser
RUN tar zxf /root/stash.tar.gz --strip=1 -C /opt/stash
RUN mv /opt/stash/conf/server.xml /opt/stash/conf/server-backup.xml
# Install JDBC driver
RUN curl -Lks http://repo.sbb.ch/service/local/artifact/maven/redirect?r=proxy.external.nexus-ext-cache.releases&g=mysql&a=mysql-connector-java&v=${mysqlconnectorversion}&e=jar -o /opt/stash/lib/mysql-connector-java-${mysqlconnectorversion}-bin.jar

#Setting Java Home
RUN sed -i 's,#!/usr/bin/env bash,#!/usr/bin/env bash\n#\n#Customizing for SBB\n#\n# setting JAVA_HOME\nJAVA_HOME="/opt/jdk",g' /opt/stash/bin/setenv.sh 

#Setting Stash Home
RUN sed -i 's,#STASH_HOME="",STASH_HOME="/var/data/atlassian-base",g' /opt/stash/bin/setenv.sh
RUN chown -R stash:atlassian /opt/stash