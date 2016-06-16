FROM registry.sbb.ch/kd_wzu/base8
MAINTAINER Sebastian Graf <sebastian.graf@sbb.ch>

#Environment Variables

ENV GITVERSION 2.8.2
ENV CODEVERSION 4.6.2
ENV MYSQLCONNECTORVERSION 5.1.35
ENV IDOFFSET 120
ENV APPUSER code
ENV DATADIR /var/data
ENV BITBUCKET_HOME ${DATADIR}/code
ENV PLUGINFOLDER ${BITBUCKET_HOME}/shared/plugins/installed-plugins
ENV PATH /usr/local/bin:/sbin:/usr/sbin:/usr/bin:/bin
ENV JAVA_HOME /opt/jdk


#Updating Git, MWESERVICE-11177
RUN wget --quiet http://p2.sbb.ch/service/local/repositories/site.wzu-rpms/content/git-${GITVERSION}-1.el7.centos.x86_64.rpm -O /tmp/git.rpm \
    && wget --quiet http://p2.sbb.ch/service/local/repositories/site.wzu-rpms/content/perl-Git-${GITVERSION}-1.el7.centos.x86_64.rpm -O /tmp/git-perl.rpm \
    && yum -y remove git perl-Git \
    && yum -y install /tmp/git.rpm /tmp/git-perl.rpm \
    && rm -f /tmp/git.rpm /tmp/git-perl.rpm \
    && git --version

# Create Data directory structure
RUN mkdir -p ${BITBUCKET_HOME} \
    && adduser ${APPUSER} -U -u 1${IDOFFSET} --home ${BITBUCKET_HOME} \
    && mkdir -p ${PLUGINFOLDER}

#Getting code and setting it up and backing up old settings
RUN wget --quiet http://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-${CODEVERSION}.tar.gz -O /opt/atlassian-code-${CODEVERSION}.tar.gz \
    && cd /opt \
    && tar xfz atlassian-code-${CODEVERSION}.tar.gz \
    && rm -f /opt/atlassian-code-${CODEVERSION}.tar.gz \
    && ln -s /opt/atlassian-bitbucket* /opt/code \
    && chown -R ${APPUSER}:${APPUSER} /opt/atlassian-bitbucket* \
    && mv /opt/code/bin/setenv.sh /opt/code/bin/setenv-backup.sh

# Install JDBC driver
RUN wget --quiet "http://repo.sbb.ch/content/groups/mirror/mysql/mysql-connector-java/${MYSQLCONNECTORVERSION}/mysql-connector-java-${MYSQLCONNECTORVERSION}.jar" -O /opt/code/lib/mysql-connector-java-${MYSQLCONNECTORVERSION}-bin.jar


#Categories in Version 1.3.2
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/de.communardo.plugin.stash-project-categories/version/100000051 -O  ${PLUGINFOLDER}/code-project-categories.jar
#Workzone in Version 4.2.4
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.izymes.workzone/version/4020400040 -O ${PLUGINFOLDER}/workzone.jar
#Unmerged Branch Hook in Version 2.0.0
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.stash.plugin.stash-protect-unmerged-branch-hook/version/200 -O ${PLUGINFOLDER}/code-protect-unmerged-branch-hook.jar
#REST API Browser in Version 3.2.0
RUN wget --quiet https://marketplace.atlassian.com/download/plugins/com.atlassian.labs.rest-api-browser/version/30200 -O ${PLUGINFOLDER}/rest-browser.jar
#Webhook in Version 3.0
RUN wget --quiet http://repo.sbb.ch/service/local/repositories/mirror/content/ch/sbb/stash/jenkins-push-webhook/3.0/jenkins-push-webhook-3.0.jar -O ${PLUGINFOLDER}/jenkins-push-webhook.jar
#Commit Enforcer in Version 3.0
RUN wget --quiet http://repo.sbb.ch/service/local/repositories/mirror/content/ch/sbb/stash/enforce-message-hook-plugin/3.0/enforce-message-hook-plugin-3.0.jar -O ${PLUGINFOLDER}/enforce-message-hook-plugin.jar

# Mounting Config, growing files, logs and repos externally
RUN ln -s ${DATADIR}/mounted/conf/code-config.properties ${BITBUCKET_HOME}/shared/bitbucket.properties \
    && ln -sf ${DATADIR}/mounted/conf/server.xml ${BITBUCKET_HOME}/shared/server.xml \
    && ln -sf ${DATADIR}/mounted/bitbucket-log ${BITBUCKET_HOME}/log \
    && ln -sf ${DATADIR}/mounted/caches ${BITBUCKET_HOME}/caches \
    && ln -sf ${DATADIR}/mounted/data ${BITBUCKET_HOME}/shared/data \
    && rm -rf /opt/code/logs \
    && ln -sf ${DATADIR}/mounted/catalina-log /opt/code/logs

#Exposing Port to make Code accessible
EXPOSE 7999 8120 9120 10120 11120

#Getting files to set image
COPY configs/setenv.sh /opt/code/bin/setenv.sh
COPY configs/code.sh /opt/code/code.sh
COPY configs/ssh-server-keys.pem ${BITBUCKET_HOME}/shared/config/ssh-server-keys.pem
RUN chmod 755 /opt/code/bin/setenv.sh /opt/code/code.sh

RUN chown -R ${APPUSER}:${APPUSER} ${BITBUCKET_HOME} \
    && chown -R ${APPUSER}:${APPUSER} /opt/code \
    && chown -R ${APPUSER}:${APPUSER} ${BITBUCKET_HOME}

USER code
CMD "/opt/code/code.sh"
