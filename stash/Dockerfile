FROM schweizerischebundesbahnen/atlassian-base
MAINTAINER Sebastian Graf <sebastian.graf@sbb.ch>

ENV STASH_VERSION 2.12.5
RUN yum install -q git-core -y
RUN curl -Lks http://www.atlassian.com/software/stash/downloads/binary/atlassian-stash-${STASH_VERSION}.tar.gz -o /root/stash.tar.gz
RUN /usr/sbin/useradd --create-home --home-dir /opt/stash --groups atlassian --shell /bin/bash stash
RUN tar zxf /root/stash.tar.gz --strip=1 -C /opt/stash
RUN sed -i -e "s/^#!\/bin\/sh/#!\/bin\/bash/" /opt/stash/bin/catalina.sh
RUN mv /opt/stash/conf/server.xml /opt/stash/conf/server-backup.xml
RUN chown -R stash:stash /opt/stash

#Plugin download
#Universal Plugin in Version 2.15.2
RUN curl -Lks https://marketplace.atlassian.com/download/plugins/com.atlassian.upm.atlassian-universal-plugin-manager-plugin/version/138571 -o /opt/atlassian-home/plugins/installed-plugins/atlassian-universal-plugin-manager-plugin.jar
#Categories in Version 0.4
RUN curl -Lks https://marketplace.atlassian.com/download/plugins/de.communardo.plugin.stash-project-categories/version/400100 -o  /opt/atlassian-home/plugins/installed-plugins/stash-project-categories.jar
#Workzone in Version 1.3.1
RUN curl -Lks https://marketplace.atlassian.com/download/plugins/com.izymes.workzone/version/1003001010 -o /opt/atlassian-home/plugins/installed-plugins/workzone.jar
#Unmerged Branch Hook in Version 1.1
RUN curl -Lks https://marketplace.atlassian.com/download/plugins/com.atlassian.stash.plugin.stash-protect-unmerged-branch-hook/version/110 -o /opt/atlassian-home/plugins/installed-plugins/stash-protect-unmerged-branch-hook.jar
#Webhook in Version 2.0
RUN curl -Lks http://repo.sbb.ch/service/local/repositories/hosted.mwe-wzu.releases/content/ch/sbb/stash/jenkins-push-webhook/2.0.0/jenkins-push-webhook-2.0.0.jar -o /opt/atlassian-home/plugins/installed-plugins/jenkins-push-webhook.jar
#Commit Enforcer in Version 2.0
RUN curl -Lks http://repo.sbb.ch/service/local/repositories/hosted.mwe-wzu.releases/content/ch/sbb/stash/enforce-message-hook-plugin/2.0/enforce-message-hook-plugin-2.0.jar -o /opt/atlassian-home/plugins/installed-plugins/enforce-message-hook-plugin.jar




ENV CONTEXT_PATH ROOT
ADD launch.bash /launch

# Launching Stash

WORKDIR /opt/stash
VOLUME /var/data/stash:/opt/atlassian-home
EXPOSE 7990 7999
USER stash
CMD ["/launch"]