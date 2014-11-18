# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/atlassian-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

#Environment variables
ENV domain issues-t.sbb.ch
ENV jiraversion 6.3.7
ENV datadir /var/data
ENV jirahome /var/data/jira
ENV portoffset 70
ENV appuser jira
ENV filerurl http://wzufiler.sbb.ch 
ENV JAVA_HOME /opt/jdk17
ENV mysqlconnectorversion 5.1.32

# Create Data directory structure and add user jira to the image
RUN mkdir -p ${datadir} && adduser ${appuser} -U -u 10${portoffset} --home ${jirahome}

# Import the default keystore
RUN wget --quiet ${filerurl}/keystore -O /opt/jdk/jre/lib/security/cacerts

# Download jira into /opt
RUN wget --quiet http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-${jiraversion}.tar.gz -O /opt/atlassian-jira-${jiraversion}.tar.gz \
	&& cd /opt \
	&& tar xfz atlassian-jira-${jiraversion}.tar.gz \
	&& rm -f /opt/atlassian-jira-${jiraversion}.tar.gz \
	&& ln -s /opt/atlassian-jira* /opt/jira \
	&& chown -R ${appuser}:${appuser} ${jirahome} /opt/atlassian-jira* /opt/jdk* \
	&& wget --quiet ${filerurl}/jira/setenv.sh-prod -O /opt/jira/bin/setenv.sh && wget --quiet ${filerurl}/jira/server.xml-prod -O /opt/jira/conf/server.xml

# Install JDBC driver
RUN wget --quiet "http://repo.sbb.ch/service/local/artifact/maven/redirect?r=proxy.external.nexus-ext-cache.releases&g=mysql&a=mysql-connector-java&v=${mysqlconnectorversion}&e=jar" -O /opt/jira/lib/mysql-connector-java-${mysqlconnectorversion}-bin.jar

# Link logs and temp
RUN rm -rf /opt/jira/{logs,temp} && mkdir -p ${jirahome}/{logs,temp} && ln -sf ${jirahome}/logs /opt/jira/logs && ln -sf ${jirahome}/temp /opt/jira/temp

# Standard JIRA-Port AJP
EXPOSE 9070

# Standard JIRA-Port http
EXPOSE 8070

# Standard JIRA-Port JMX
EXPOSE 10070

# Create run.sh
RUN echo "sed -i 's/10.134.205.202/`ifconfig eth0 | grep 'inet addr' | cut -d":" -f2 | cut -d" " -f1`/g' /opt/jira/bin/setenv.sh" >> /root/run.sh && chmod +x /root/run.sh

# Start jira
CMD /bin/bash /root/run.sh && sed -i "s/issues.sbb.ch/$domain/g" /opt/jira/conf/server.xml && su - jira -c 'export JAVA_HOME=/opt/jdk17 && /opt/jira/bin/start-jira.sh' && tail -f /opt/jira/logs/catalina.out
