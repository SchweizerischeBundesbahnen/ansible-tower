FROM schweizerischebundesbahnen/stash-base:3.4.1
MAINTAINER Sebastian Graf <sebastian.graf@sbb.ch>

#Stash Base installed with java and stash in /opt.
#Only Stuff in /var/data/atlassian-base

ENV filer_url http://wzufiler.sbb.ch 

#Plugin download
RUN mkdir -p $stash_home/plugins/installed-plugins 

#Universal Plugin in Version 2.18.1
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.upm.atlassian-universal-plugin-manager-plugin/version/138571 -O $stash_home/plugins/installed-plugins/atlassian-universal-plugin-manager-plugin.jar
#Categories in Version 1.0
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/de.communardo.plugin.stash-project-categories/version/100000000 -O  $stash_home/plugins/installed-plugins/stash-project-categories.jar
#Workzone in Version 2.1.3
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.izymes.workzone/version/2001003010 -O $stash_home/plugins/installed-plugins/workzone.jar
#Unmerged Branch Hook in Version 1.1
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.stash.plugin.stash-protect-unmerged-branch-hook/version/110 -O $stash_home/plugins/installed-plugins/stash-protect-unmerged-branch-hook.jar
#Webhook in Version 2.0
RUN wget --quiet http://repo.sbb.ch/service/local/repositories/hosted.mwe-wzu.releases/content/ch/sbb/stash/jenkins-push-webhook/2.0.0/jenkins-push-webhook-2.0.0.jar -O $stash_home/plugins/installed-plugins/jenkins-push-webhook.jar
#Commit Enforcer in Version 2.0
RUN wget --quiet http://repo.sbb.ch/service/local/repositories/hosted.mwe-wzu.releases/content/ch/sbb/stash/enforce-message-hook-plugin/2.0/enforce-message-hook-plugin-2.0.jar -O $stash_home/plugins/installed-plugins/enforce-message-hook-plugin.jar

#Getting config and server.xml. server.xml is adapted later to test-/whatever instances
RUN wget --quiet ${filer_url}/stash/stash-config.properties-test -O $stash_home/shared/stash-config.properties && wget --quiet ${filer_url}/stash/server.xml-test -P /opt/stash/conf/server.xml

ENV wzuuser wzuuser
RUN /usr/sbin/useradd --create-home --home-dir /home/${wzuuser} --groups wheel --shell /bin/bash $wzuuser
RUN echo "${wzuuser}:${wzuuser}" | chpasswd
RUN echo "${wzuuser} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# don't use pam in ssh
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]