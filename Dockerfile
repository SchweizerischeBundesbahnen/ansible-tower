# Ansible Tower Dockerfie

FROM ubuntu:14.04
#Image based on https://github.com/ybalt/ansible-tower 
MAINTAINER sebastian.graf@sbb.ch

ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/SchweizerischeBundesbahnen/ansible-tower"

ENV ANSIBLE_TOWER_VER 3.0.3
ENV USER root

RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y software-properties-common wget curl bsdmainutils python-dev libssl-dev  \
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

RUN cd /opt/tower-setup \
    && ./setup.sh \
    && ansible-tower-service stop

# / CDP-174, CDP-209, GISSRV-989 Adding windows modules
RUN /bin/bash -c "source /var/lib/awx/venv/ansible/bin/activate; pip install --upgrade pywinrm; pip install --upgrade pyOpenSSL; pip install pywinrm[credssp]; deactivate;"
# \ CDP-174, CDP-209, GISSRV-989 Adding windows modules

#Backuping generated live data because various sources should be injected externally
RUN echo "" \
    && echo "Caring about postgres-database, data, certs, settings, logs" \
    && mv /var/lib/postgresql/9.4 /var/lib/postgresql/9.4.bak \
    && mv /var/lib/awx /var/lib/awx.bak \
    && mv /var/log/ /var/log.bak

ADD scripts/docker-entrypoint.sh /docker-entrypoint.sh
ADD scripts/backup.sh /backup.sh
ADD scripts/restore.sh /restore.sh
RUN chmod +x /docker-entrypoint.sh /backup.sh /restore.sh

EXPOSE 80 443 11230

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]