# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/base
MAINTAINER Pascal Bieri <pascal.bieri@sbb.ch>

#Environment variables
ENV jiraversion 6.4.4
ENV datadir /var/data
ENV jirahome /var/data/jira
ENV idoffset 70
ENV appuser jira
ENV mysqlconnectorversion 5.1.35

# Create Data directory structure and add user jira to the image
RUN mkdir -p ${datadir} && adduser ${appuser} -U -u 10${idoffset} --home ${jirahome}

# Download jira into /opt
RUN	cd /opt \
	&& wget -qO- http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-${jiraversion}.tar.gz | tar xfz - \
	&& ln -s /opt/atlassian-jira* /opt/jira \
	&& chown -R ${appuser}:${appuser} ${jirahome} /opt/atlassian-jira* /opt/jdk*

# Install JDBC driver
RUN wget --quiet "http://repo.sbb.ch/content/groups/mirror/mysql/mysql-connector-java/${mysqlconnectorversion}/mysql-connector-java-${mysqlconnectorversion}.jar" -O /opt/jira/lib/mysql-connector-java-${mysqlconnectorversion}-bin.jar

# Link logs and temp
RUN rm -rf /opt/jira/{logs,temp} && mkdir -p ${jirahome}/{logs,temp} && ln -sf ${jirahome}/logs /opt/jira/logs && ln -sf ${jirahome}/temp /opt/jira/temp

# Standard JIRA-Port AJP
EXPOSE 9070

# Standard JIRA-Port http
EXPOSE 8070

# Standard JIRA-Port JMX
EXPOSE 10070

# Install script for jira
COPY configs/jira.ini /etc/supervisor/conf.d/

# Supervisor can not use env variables
RUN sed -ri "s/APP_USER/${appuser}/g" /etc/supervisor/conf.d/jira.ini

# jira configuration
COPY configs/server.xml /opt/jira/conf/
COPY configs/setenv.sh /opt/jira/bin/
RUN chmod 755  /opt/jira/bin/setenv.sh

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
