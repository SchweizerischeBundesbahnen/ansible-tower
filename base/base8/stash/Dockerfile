FROM registry.sbb.ch/kd_wzu/base8
MAINTAINER Sebastian Graf <sebastian.graf@sbb.ch>

#Environment Variables

ENV gitversion 1.8.5.5
ENV stashversion 3.11.4
ENV mysqlconnectorversion 5.1.35
ENV idoffset 120
ENV appuser stash
ENV datadir /var/data
ENV stash_home /var/data/stash
ENV plugin_folder ${stash_home}/shared/plugins/installed-plugins
ENV PATH /usr/local/bin:/sbin:/usr/sbin:/usr/bin:/bin

# Create Data directory structure and add user jira to the image
RUN mkdir -p ${datadir} && adduser ${appuser} -U -u 1${idoffset} --home ${stash_home} && mkdir -p ${stash_home}/shared && mkdir -p ${plugin_folder}

#Getting stash and setting it up and backing up old settings
RUN wget --quiet http://www.atlassian.com/software/stash/downloads/binary/atlassian-stash-${stashversion}.tar.gz -O /opt/atlassian-stash-${stashversion}.tar.gz \
	&& cd /opt \
	&& tar xfz atlassian-stash-${stashversion}.tar.gz \
	&& rm -f /opt/atlassian-stash-${stashversion}.tar.gz \
	&& ln -s /opt/atlassian-stash* /opt/stash \
	&& chown -R ${appuser}:${appuser} /opt/atlassian-stash* \
	&& mv /opt/stash/bin/setenv.sh /opt/stash/bin/setenv-backup.sh

# Install JDBC driver
RUN wget --quiet "http://repo.sbb.ch/content/groups/mirror/mysql/mysql-connector-java/${mysqlconnectorversion}/mysql-connector-java-${mysqlconnectorversion}.jar" -O /opt/stash/lib/mysql-connector-java-${mysqlconnectorversion}-bin.jar

#Universal Plugin in Version 2.20.4
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.upm.atlassian-universal-plugin-manager-plugin/version/138721 -O ${plugin_folder}/atlassian-universal-plugin-manager-plugin.jar
#Support Tools Plugin in Version 3.7.0
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.support.stp/version/30700 -O ${plugin_folder}/atlassian-support-tools-plugin.jar
#Categories in Version 1.1
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/de.communardo.plugin.stash-project-categories/version/100000010 -O  ${plugin_folder}/stash-project-categories.jar
#Workzone in Version 3.1.2
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.izymes.workzone/version/3001002020 -O ${plugin_folder}/workzone.jar
#Unmerged Branch Hook in Version 1.1
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.stash.plugin.stash-protect-unmerged-branch-hook/version/110 -O ${plugin_folder}/stash-protect-unmerged-branch-hook.jar
#Webhook in Version 2.1.1
RUN wget --quiet http://repo.sbb.ch/content/repositories/hosted.mwe-wzu.releases/ch/sbb/stash/jenkins-push-webhook/2.1.2/jenkins-push-webhook-2.1.2.jar -O ${plugin_folder}/jenkins-push-webhook.jar
#Commit Enforcer in Version 2.2
RUN wget --quiet http://repo.sbb.ch/service/local/repositories/hosted.mwe-wzu.releases/content/ch/sbb/stash/enforce-message-hook-plugin/2.2/enforce-message-hook-plugin-2.2.jar -O ${plugin_folder}/enforce-message-hook-plugin.jar

# Mounting Config, growing files, logs and repos externally
RUN ln -s ${datadir}/mounted/conf/stash-config.properties ${stash_home}/shared/stash-config.properties \
    && ln -s ${datadir}/mounted/conf/server.xml ${stash_home}/shared/server.xml \
    && ln -s ${datadir}/mounted/log ${stash_home}/log \
    && ln -s ${datadir}/mounted/caches ${stash_home}/caches \
    && ln -s ${datadir}/mounted/data ${stash_home}/shared/data

#Exposing Port to make Stash accessible
EXPOSE 7999 8120 9120 10120 11120

#Getting files to set image
COPY configs/setenv.sh /opt/stash/bin/setenv.sh
COPY configs/stash.sh /opt/stash/stash.sh
COPY configs/ssh-server-keys.pem ${stash_home}/shared/config/ssh-server-keys.pem
RUN chmod 755 /opt/stash/bin/setenv.sh /opt/stash/stash.sh

RUN chown -R ${appuser}:${appuser} ${stash_home}
USER stash
CMD "/opt/stash/stash.sh"
