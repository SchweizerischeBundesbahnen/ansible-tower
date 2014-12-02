FROM schweizerischebundesbahnen/stash-base:3.4.1-1
MAINTAINER Roger Bobst <roger.bobst@sbb.ch>

#Stash Base installed with java and stash in /opt.
#Only Stuff in /var/data/stash

ENV stash_home /var/data/stash
ENV plugin_folder ${stash_home}/shared/plugins/installed-plugins
ENV filerurl http://30020.hostserv.eu

#Plugin download
RUN mkdir -p ${plugin_folder}

#Universal Plugin in Version 2.18.1
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.upm.atlassian-universal-plugin-manager-plugin/version/138571 -O ${plugin_folder}/atlassian-universal-plugin-manager-plugin.jar

#Categories in Version 1.0
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/de.communardo.plugin.stash-project-categories/version/100000000 -O  ${plugin_folder}/stash-project-categories.jar

#Workzone in Version 2.1.4
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.izymes.workzone/version/2001004000 -O ${plugin_folder}/workzone.jar

#Unmerged Branch Hook in Version 1.1
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.stash.plugin.stash-protect-unmerged-branch-hook/version/110 -O ${plugin_folder}/stash-protect-unmerged-branch-hook.jar

#Webhook in Version 2.0
RUN wget --quiet ${filer_url}/stash/jenkins-push-webhook.jar -O ${plugin_folder}/jenkins-push-webhook.jar
#Commit Enforcer in Version 2.0
RUN wget --quiet ${filer_url}/stash/enforce-message-hook-plugin-2.0.jar -O ${plugin_folder}/enforce-message-hook-plugin.jar

#Getting config and server.xml. server.xml is adapted later to test-/whatever instances
RUN wget --quiet ${filer_url}/stash/stash-config.properties-ext -O ${stash_home}/shared/stash-config.properties \
        && wget --quiet ${filer_url}/stash/server.xml-ext -O /opt/stash/conf/server.xml

RUN chown -R ${appuser}:${appuser} $stash_home

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

