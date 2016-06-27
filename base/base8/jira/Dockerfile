# This Dockerfile is used to build an image containing basic stuff to be used as Jira
FROM registry.sbb.ch/kd_wzu/base8
MAINTAINER Pascal Bieri <pascal.bieri@sbb.ch>

#Environment variables
ENV datadir /var/data
ENV jirahome /var/data/jira
ENV idoffset 20
ENV appuser jira
ENV mysqlconnectorversion 5.1.38
ENV jiraversion 7.1.8

# Create Data directory structure and add user jira to the image
RUN mkdir -p ${datadir} && adduser ${appuser} -U -u 10${idoffset} --home ${jirahome}

# Download jira into /opt
RUN	cd /opt \
	&& wget -qO- http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${jiraversion}-jira-${jiraversion}.tar.gz | tar xfz - \
	&& ln -s /opt/atlassian-jira* /opt/jira \
	&& chown -R ${appuser}:${appuser} ${jirahome} /opt/atlassian-jira* /opt/jdk*

# Install JDBC driver
RUN wget --quiet "http://repo.sbb.ch/content/groups/mirror/mysql/mysql-connector-java/${mysqlconnectorversion}/mysql-connector-java-${mysqlconnectorversion}.jar" -O /opt/jira/lib/mysql-connector-java-${mysqlconnectorversion}-bin.jar

# Link logs and temp
RUN rm -rf /opt/jira/{logs,temp} && mkdir -p ${jirahome}/{logs,temp} && ln -sf ${jirahome}/logs /opt/jira/logs && ln -sf ${jirahome}/temp /opt/jira/temp

# Standard JIRA-Port AJP
EXPOSE 8020 9020 10020

# jira configuration
COPY configs/server.xml /opt/jira/conf/
COPY configs/setenv.sh /opt/jira/bin/
RUN chmod 755  /opt/jira/bin/setenv.sh
COPY configs/jira.sh /opt/jira/jira.sh

USER jira

# run jira
CMD "/opt/jira/jira.sh"
