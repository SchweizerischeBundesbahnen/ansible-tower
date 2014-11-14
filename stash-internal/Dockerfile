FROM schweizerischebundesbahnen/stash-base:3.4.1
MAINTAINER Sebastian Graf <sebastian.graf@sbb.ch>

#Stash Base installed with java and stash in /opt.
#Only Stuff in /var/data/atlassian-base
ENV stash_home /var/data/atlassian-base
ENV filer_url http://wzufiler.sbb.ch 
ENV appname stash

ENV JAVA_OPTIONS -Xmx1024m
ENV JAVA_RUNTIME /opt/jdk17/bin/java

#Plugin download
RUN mkdir -p $stash_home/plugins/installed-plugins && mkdir -p $stash_home/shared

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

WORKDIR /opt/stash

#Getting config and server.xml. server.xml is adapted later to test-/whatever instances
RUN wget --quiet ${filer_url}/stash/stash-config.properties-test -O $stash_home/shared/stash-config.properties && wget --quiet ${filer_url}/stash/server.xml-test -P /opt/stash/conf/server.xml

# Adding run user
RUN adduser $appname 
# RUN chown -R $appname:$appname $stash_home
EXPOSE 8090

# install script for stash
COPY configs/stash.ini /etc/supervisor/conf.d/

# supervisor can not use env variables
RUN sed -ri "s/APP_USER/${appname}/g" /etc/supervisor/conf.d/stash.ini

#Linking logs and repositories in container
VOLUME /var/data/stash/log:$stash_home/log
VOLUME /var/data/stash/logs:$stash_home/logs
VOLUME /var/data/stash/shared:$stash_home/shared/data

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]