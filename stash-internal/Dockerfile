FROM schweizerischebundesbahnen/stash-base

MAINTAINER Sebastian Graf <sebastian.graf@sbb.ch>

#Stash Base installed with java and stash in /opt.
#Only Stuff in /var/data/stash

ENV stash_home /var/data/stash
ENV plugin_folder ${stash_home}/shared/plugins/installed-plugins

#Plugin download
RUN mkdir -p ${plugin_folder}

#Universal Plugin in Version 2.18.2
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.upm.atlassian-universal-plugin-manager-plugin/version/138581 -O ${plugin_folder}/atlassian-universal-plugin-manager-plugin.jar
#Categories in Version 1.0
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/de.communardo.plugin.stash-project-categories/version/100000000 -O  ${plugin_folder}/stash-project-categories.jar
#Workzone in Version 2.4.0
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.izymes.workzone/version/2004000010 -O ${plugin_folder}/workzone.jar
#Unmerged Branch Hook in Version 1.1
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.stash.plugin.stash-protect-unmerged-branch-hook/version/110 -O ${plugin_folder}/stash-protect-unmerged-branch-hook.jar
#Webhook in Version 2.0
RUN wget --quiet http://repo.sbb.ch/service/local/repositories/hosted.mwe-wzu.releases/content/ch/sbb/stash/jenkins-push-webhook/2.0.3/jenkins-push-webhook-2.0.3.jar -O ${plugin_folder}/jenkins-push-webhook.jar
#Commit Enforcer in Version 2.0
RUN wget --quiet http://repo.sbb.ch/service/local/repositories/hosted.mwe-wzu.releases/content/ch/sbb/stash/enforce-message-hook-plugin/2.0/enforce-message-hook-plugin-2.0.jar -O ${plugin_folder}/enforce-message-hook-plugin.jar

#Getting server.xml
COPY configs/server.xml /opt/stash/conf/server.xml

RUN chown -R ${appuser}:${appuser} $stash_home

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
