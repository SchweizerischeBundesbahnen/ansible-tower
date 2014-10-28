FROM schweizerischebundesbahnen/stash-base
MAINTAINER Sebastian Graf <sebastian.graf@sbb.ch>

#Stash Base installed with java and stash in /opt.
#Only Stuff in /var/data/atlassian-base
ENV STASH_HOME /var/data/atlassian-base
ENV FILER_URL http://wzufiler.sbb.ch 
ENV DOMAIN code-t.sbb.ch

#Plugin download
RUN mkdir -p $STASH_HOME/plugins/installed-plugins

#Universal Plugin in Version 2.15.2
RUN curl -Lks https://marketplace.atlassian.com/download/plugins/com.atlassian.upm.atlassian-universal-plugin-manager-plugin/version/138571 -o $STASH_HOME/plugins/installed-plugins/atlassian-universal-plugin-manager-plugin.jar
#Categories in Version 0.4
RUN curl -Lks https://marketplace.atlassian.com/download/plugins/de.communardo.plugin.stash-project-categories/version/400100 -o  $STASH_HOME/plugins/installed-plugins/stash-project-categories.jar
#Workzone in Version 1.3.1
RUN curl -Lks https://marketplace.atlassian.com/download/plugins/com.izymes.workzone/version/1003001010 -o $STASH_HOME/plugins/installed-plugins/workzone.jar
#Unmerged Branch Hook in Version 1.1
RUN curl -Lks https://marketplace.atlassian.com/download/plugins/com.atlassian.stash.plugin.stash-protect-unmerged-branch-hook/version/110 -o $STASH_HOME/plugins/installed-plugins/stash-protect-unmerged-branch-hook.jar
#Webhook in Version 2.0
RUN curl -Lks http://repo.sbb.ch/service/local/repositories/hosted.mwe-wzu.releases/content/ch/sbb/stash/jenkins-push-webhook/2.0.0/jenkins-push-webhook-2.0.0.jar -o $STASH_HOME/plugins/installed-plugins/jenkins-push-webhook.jar
#Commit Enforcer in Version 2.0
RUN curl -Lks http://repo.sbb.ch/service/local/repositories/hosted.mwe-wzu.releases/content/ch/sbb/stash/enforce-message-hook-plugin/2.0/enforce-message-hook-plugin-2.0.jar -o $STASH_HOME/plugins/installed-plugins/enforce-message-hook-plugin.jar

WORKDIR /opt/stash
#Linking logs and repositories in container
VOLUME /var/data/stash/log:$STASH_HOME/log
VOLUME /var/data/stash/logs:$STASH_HOME/logs
VOLUME /var/data/stash/data:$STASH_HOME/data

#Getting config and server.xml. server.xml is adapted later to test-/whatever instances
RUN curl -Lks ${FILER_URL}/stash/stash-config.properties-test -o $STASH_HOME/stash-config.properties 
RUN curl -Lks ${FILER_URL}/stash/server.xml-prod -o /opt/stash/conf/server.xml

RUN chown -R stash:atlassian $STASH_HOME

RUN echo "sed -i 's/10.134.205.228/`ifconfig eth0 | grep 'inet addr' | cut -d":" -f2 | cut -d" " -f1`/g' /opt/stash/bin/setenv.sh" > /root/run.sh && chmod +x /root/run.sh

EXPOSE 8090

CMD /bin/bash /root/run.sh && sed -i "s/code.sbb.ch/$DOMAIN/g" /opt/stash/conf/server.xml && su - stash -c 'export JAVA_HOME=/opt/jdk && /opt/stash/bin/start-stash.sh' && tail -f /opt/stash/logs/catalina.out