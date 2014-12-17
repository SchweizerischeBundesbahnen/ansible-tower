FROM schweizerischebundesbahnen/base
MAINTAINER Roger Bobst <roger.bobst@sbb.ch>

ENV idoffset 40
ENV appuser confluence
ENV datadir /var/data
ENV confluence_version 5.4.4
ENV confluence_home /var/data/confluence
ENV mysqlconnectorversion 5.1.32
ENV filer_url http://wzufiler.sbb.ch 

# Create Data directory structure and add user to the image
RUN mkdir -p ${datadir} \
	&& adduser ${appuser} -U -u 10${idoffset} --home ${confluence_home} 

# Getting confluence and setting it
RUN wget --quiet http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${confluence_version}.tar.gz -O /opt/atlassian-confluence-${confluence_version}.tar.gz \
	&& cd /opt \
	&& tar xfz atlassian-confluence-${confluence_version}.tar.gz \
	&& rm -f /opt/atlassian-confluence-${confluence_version}.tar.gz \
	&& ln -s /opt/atlassian-confluence* /opt/confluence

# Backup default configuration
RUN mv /opt/confluence/conf/server.xml /opt/confluence/conf/server-backup.xml \
	&& mv /opt/confluence/bin/setenv.sh /opt/confluence/bin/setenv-backup.sh

# Install JDBC driver
RUN wget --quiet "http://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/${mysqlconnectorversion}/mysql-connector-java-${mysqlconnectorversion}.jar" -O /opt/confluence/lib/mysql-connector-java-${mysqlconnectorversion}-bin.jar

# According to https://confluence.atlassian.com/x/Fh6_Eg , some folders must be writable
RUN chown -R ${appuser}:${appuser} /opt/confluence/logs /opt/confluence/temp

# Exposing Port to make Confluence accessible
EXPOSE 8040
EXPOSE 9040

# Install script for confluence
COPY configs/confluence.ini /etc/supervisor/conf.d/

# Supervisor can not use env variables
RUN sed -ri "s/APP_USER/${appuser}/g" /etc/supervisor/conf.d/confluence.ini

# Confluence configuration
RUN wget --quiet ${filer_url}/confluence/server.xml-int -O /opt/confluence/conf/server.xml \
	&& wget --quiet ${filer_url}/confluence/setenv.sh-int -O /opt/confluence/bin/setenv.sh \
	&& chmod 755  /opt/confluence/bin/setenv.sh

# Set confluence home in properties file
RUN echo "confluence.home=/var/data/confluence" >>  /opt/confluence/confluence/WEB-INF/classes/confluence-init.properties

RUN chown -R ${appuser}:${appuser} $confluence_home

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
