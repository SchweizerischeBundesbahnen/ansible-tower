FROM registry.sbb.ch/kd_wzu/base8
MAINTAINER Sebastian Graf <sebastian.graf@sbb.ch>

#Environment Variables

ENV codeversion 4.4.0
ENV mysqlconnectorversion 5.1.35
ENV idoffset 120
ENV appuser code
ENV datadir /var/data
ENV code_home /var/data/code
ENV plugin_folder ${code_home}/shared/plugins/installed-plugins
ENV PATH /usr/local/bin:/sbin:/usr/sbin:/usr/bin:/bin

# Create Data directory structure and add user jira to the image
RUN mkdir -p ${datadir} && adduser ${appuser} -U -u 1${idoffset} --home ${code_home} && mkdir -p ${code_home}/shared && mkdir -p ${plugin_folder}

#Getting code and setting it up and backing up old settings
RUN wget --quiet http://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-${codeversion}.tar.gz -O /opt/atlassian-code-${codeversion}.tar.gz \
	&& cd /opt \
	&& tar xfz atlassian-code-${codeversion}.tar.gz \
	&& rm -f /opt/atlassian-code-${codeversion}.tar.gz \
	&& ln -s /opt/atlassian-bitbucket* /opt/code \
	&& chown -R ${appuser}:${appuser} /opt/atlassian-bitbucket* \
	&& mv /opt/code/bin/setenv.sh /opt/code/bin/setenv-backup.sh

# Install JDBC driver
RUN wget --quiet "http://repo.sbb.ch/content/groups/mirror/mysql/mysql-connector-java/${mysqlconnectorversion}/mysql-connector-java-${mysqlconnectorversion}.jar" -O /opt/code/lib/mysql-connector-java-${mysqlconnectorversion}-bin.jar

#Universal Plugin in Version 2.20.7
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.upm.atlassian-universal-plugin-manager-plugin/version/138751 -O ${plugin_folder}/atlassian-universal-plugin-manager-plugin.jar
#Support Tools Plugin in Version 3.7.22
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.support.stp/version/30765 -O ${plugin_folder}/atlassian-support-tools-plugin.jar
#Categories in Version 1.3.1
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/de.communardo.plugin.stash-project-categories/version/100000041 -O  ${plugin_folder}/code-project-categories.jar
#Workzone in Version 4.2.0
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.izymes.workzone/version/4020000000 -O ${plugin_folder}/workzone.jar
#Unmerged Branch Hook in Version 2.0.0
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.stash.plugin.stash-protect-unmerged-branch-hook/version/200 -O ${plugin_folder}/code-protect-unmerged-branch-hook.jar
#REST API Browser in Version 3.2.0
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.labs.rest-api-browser/version/30200 -O ${plugin_folder}/rest-browser.jar
#Webhook in Version 2.1.1, Disabled for now
#RUN wget --quiet #http://repo.sbb.ch/content/repositories/hosted.mwe-wzu.releases/ch/sbb/code/jenkins-push-webhook/2.1.2/jenkins-push-webhook-2.1.2.jar -O ${plugin_folder}/jenkins-push-webhook.jar
#Commit Enforcer in Version 2.2, Disabled for now
#RUN wget --quiet http://repo.sbb.ch/service/local/repositories/hosted.mwe-wzu.releases/content/ch/sbb/code/enforce-message-hook-plugin/2.2/enforce-message-hook-plugin-2.2.jar -O ${plugin_folder}/enforce-message-hook-plugin.jar

# since we just mount HOME/shared/data we have to link code-configuration.properties from another mount
RUN ln -s ${code_home}/conf/code-config.properties ${code_home}/shared/bitbucket.properties
RUN ln -s ${code_home}/conf/server.xml ${code_home}/shared/server.xml

#Exposing Port to make Code accessible
EXPOSE 7999 8120 9120 10120 11120

#Getting files to set image
COPY configs/setenv.sh /opt/code/bin/setenv.sh
COPY configs/code.sh /opt/code/code.sh
COPY configs/ssh-server-keys.pem ${code_home}/shared/config/ssh-server-keys.pem
RUN chmod 755 /opt/code/bin/setenv.sh /opt/code/code.sh

RUN chown -R ${appuser}:${appuser} ${code_home}
USER code
CMD "/opt/code/code.sh"
