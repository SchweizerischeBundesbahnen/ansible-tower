FROM schweizerischebundesbahnen/base8
MAINTAINER Sebastian Graf <sebastian.graf@sbb.ch>

#Environment Variables

ENV gitversion 1.8.5.5
ENV stashversion 3.9.2
ENV mysqlconnectorversion 5.1.35
ENV idoffset 120
ENV appuser stash
ENV datadir /var/data
ENV stash_home /var/data/stash
ENV plugin_folder ${stash_home}/shared/plugins/installed-plugins
ENV PATH /usr/local/bin:/sbin:/usr/sbin:/usr/bin:/bin

RUN yum install -y git && yum clean all -q 

# Create Data directory structure and add user jira to the image
RUN mkdir -p ${datadir} && adduser ${appuser} -U -u 1${idoffset} --home ${stash_home} && mkdir -p ${stash_home}/shared && mkdir -p ${plugin_folder}

#Getting stash and setting it
RUN wget --quiet http://www.atlassian.com/software/stash/downloads/binary/atlassian-stash-${stashversion}.tar.gz -O /opt/atlassian-stash-${stashversion}.tar.gz \
	&& cd /opt \
	&& tar xfz atlassian-stash-${stashversion}.tar.gz \
	&& rm -f /opt/atlassian-stash-${stashversion}.tar.gz \
	&& ln -s /opt/atlassian-stash* /opt/stash \
	&& chown -R ${appuser}:${appuser} /opt/atlassian-stash*\
	&& mv /opt/stash/conf/server.xml /opt/stash/conf/server-backup.xml

# Install JDBC driver
RUN wget --quiet "http://repo.sbb.ch/content/groups/mirror/mysql/mysql-connector-java/${mysqlconnectorversion}/mysql-connector-java-${mysqlconnectorversion}.jar" -O /opt/stash/lib/mysql-connector-java-${mysqlconnectorversion}-bin.jar

#Universal Plugin in Version 2.18.5
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.upm.atlassian-universal-plugin-manager-plugin/version/138611 -O ${plugin_folder}/atlassian-universal-plugin-manager-plugin.jar
#Categories in Version 1.0
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/de.communardo.plugin.stash-project-categories/version/100000000 -O  ${plugin_folder}/stash-project-categories.jar
#Workzone in Version 2.4.5
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.izymes.workzone/version/2004005020 -O ${plugin_folder}/workzone.jar
#Unmerged Branch Hook in Version 1.1
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.stash.plugin.stash-protect-unmerged-branch-hook/version/110 -O ${plugin_folder}/stash-protect-unmerged-branch-hook.jar
#Webhook in Version 2.1.1
RUN wget --quiet http://repo.sbb.ch/content/repositories/hosted.mwe-wzu.releases/ch/sbb/stash/jenkins-push-webhook/2.1.1/jenkins-push-webhook-2.1.1.jar -O ${plugin_folder}/jenkins-push-webhook.jar
#Commit Enforcer in Version 2.1
RUN wget --quiet http://repo.sbb.ch/service/local/repositories/hosted.mwe-wzu.releases/content/ch/sbb/stash/enforce-message-hook-plugin/2.1/enforce-message-hook-plugin-2.1.jar -O ${plugin_folder}/enforce-message-hook-plugin.jar

#Setting Java Home and Stash Home in /opt/stash/bin/setenv.sh
RUN sed -i 's,#!/usr/bin/env bash,#!/usr/bin/env bash\n#\n#Customizing for SBB\n#\n# setting JAVA_HOME\nJAVA_HOME="/opt/jdk"\nSTASH_HOME="/var/data/stash"\n\n,g' /opt/stash/bin/setenv.sh 

# since we just mount HOME/shared/data we have to link stash-configuration.properties from another mount
RUN ln -s ${stash_home}/conf/stash-config.properties ${stash_home}/shared/stash-config.properties

#Exposing Port to make Stash accessible
EXPOSE 7999 8120 9120 10120 11120

# install script for stash
COPY configs/stash.ini /etc/supervisor/conf.d/

#Getting server.xml
COPY configs/server.xml /opt/stash/conf/server.xml

RUN chown -R ${appuser}:${appuser} $stash_home

# supervisor can not use env variables
RUN sed -ri "s/APP_USER/${appuser}/g" /etc/supervisor/conf.d/stash.ini

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
