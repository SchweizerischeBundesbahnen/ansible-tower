FROM registry.sbb.ch/kd_wzu/base8
MAINTAINER Roger Bobst <roger.bobst@sbb.ch>

ENV idoffset 40
ENV appuser confluence
ENV datadir /var/data
ENV confluence_version 5.9.10
ENV confluence_home /var/data/confluence
ENV mysqlconnectorversion 5.1.38

# Create Data directory structure and add user to the image
RUN mkdir -p ${datadir} \
	&& adduser ${appuser} -U -u 10${idoffset} --home ${confluence_home} 

# Getting confluence and setting it
RUN wget --quiet http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${confluence_version}.tar.gz -O /opt/atlassian-confluence-${confluence_version}.tar.gz \
	&& cd /opt \
	&& tar xfz atlassian-confluence-${confluence_version}.tar.gz \
	&& rm -f /opt/atlassian-confluence-${confluence_version}.tar.gz \
	&& ln -s /opt/atlassian-confluence* /opt/confluence \
	&& chown -R ${appuser}:${appuser} /opt/atlassian-confluence*

# Backup default configuration
RUN mv /opt/confluence/conf/server.xml /opt/confluence/conf/server-backup.xml \
	&& mv /opt/confluence/bin/setenv.sh /opt/confluence/bin/setenv-backup.sh

# Install JDBC driver
RUN wget --quiet "http://repo.sbb.ch/content/groups/mirror/mysql/mysql-connector-java/${mysqlconnectorversion}/mysql-connector-java-${mysqlconnectorversion}.jar" -O /opt/confluence/lib/mysql-connector-java-${mysqlconnectorversion}-bin.jar

# Exposing Port to make Confluence accessible
EXPOSE 8040
EXPOSE 9040
EXPOSE 10040

# Confluence configuration
COPY configs/server.xml /opt/confluence/conf/
COPY configs/setenv.sh /opt/confluence/bin/
RUN chmod 755  /opt/confluence/bin/setenv.sh

# Set confluence home in properties file
RUN echo "confluence.home=/var/data/confluence" >  /opt/confluence/confluence/WEB-INF/classes/confluence-init.properties

RUN chown -R ${appuser}:${appuser} ${confluence_home}
COPY configs/confluence.sh /opt/confluence/confluence.sh
USER confluence
CMD "/opt/confluence/confluence.sh"
