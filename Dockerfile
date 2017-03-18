# Ansible Tower Dockerfie

FROM ubuntu:14.04
#Image based on https://github.com/ybalt/ansible-tower 
MAINTAINER sebastian.graf@sbb.ch

ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/SchweizerischeBundesbahnen/ansible-tower"

ENV ANSIBLE_TOWER_VER 3.1.1
ENV USER root

RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y software-properties-common wget curl bsdmainutils \
    # / CDP-209, GISSRV-989 Kerberos, credssp Integration
    && apt-get install -y python-dev libkrb5-dev krb5-user libffi-dev libssl-dev \
    # \ CDP-209, GISSRV-989 Kerberos, credssp Integration
    && apt-add-repository -y ppa:ansible/ansible \
    && apt-get update \
    && apt-get install -y ansible \
    && apt-get clean

ADD http://releases.ansible.com/awx/setup/ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz /opt/ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz

RUN cd /opt && tar -xvf ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz \
    && rm -rf ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz \
    && mv ansible-tower-setup-${ANSIBLE_TOWER_VER} /opt/tower-setup \
    && ls /opt/tower-setup

ADD configs/inventory /opt/tower-setup/inventory
ADD configs/krb5.conf /etc/krb5.conf

RUN locale-gen en_US.UTF-8 \
    && cd /opt/tower-setup \
    && ./setup.sh \
    && ansible-tower-service stop

# / CDP-69 Patch Jira module
ADD configs/patch.txt /tmp/patch.txt
RUN patch /usr/lib/python2.7/dist-packages/ansible/modules/extras/web_infrastructure/jira.py /tmp/patch.txt
# \ CDP-69 Patch Jira module
# / CDP-174, CDP-209, GISSRV-989 Adding windows and kerberos modules
RUN pip install --upgrade six \
    && pip install pyparsing appdirs cryptography pywinrm kerberos requests_kerberos requests-credssp
# \ CDP-174, CDP-209, GISSRV-989 Adding windows and kerberos modules

#Backuping generated live data because various sources should be injected externally
RUN echo "" \
    && echo "Caring about postgres-database, data, certs, settings, logs" \
    && mv /var/lib/postgresql/9.4 /var/lib/postgresql/9.4.bak \
    && mv /var/lib/awx/projects /var/lib/awx/projects.bak \
    && ln -s /var/lib/awx/projects /var/lib/awx-data/projects \
    && mv /var/lib/awx/job_status /var/lib/awx/job_status.bak \
    && ln -s /var/lib/awx/job_status /var/lib/awx-data/job_status \
    && mv /var/log/ /var/log.bak

ADD scripts/docker-entrypoint.sh /docker-entrypoint.sh
ADD scripts/backup.sh /backup.sh
ADD scripts/restore.sh /restore.sh
RUN chmod +x /docker-entrypoint.sh /backup.sh /restore.sh

EXPOSE 80 443 11230

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]
