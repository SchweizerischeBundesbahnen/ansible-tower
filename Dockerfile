# Ansible Tower Dockerfie

FROM ubuntu:14.04
#Image based on https://github.com/ybalt/ansible-tower 
MAINTAINER sebastian.graf@sbb.ch

ENV ANSIBLE_TOWER_VER 3.0.2
ENV USER root

RUN apt-get update \
    && apt-get install -y software-properties-common wget curl bsdmainutils\
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

# / CDP-69 Patch Jira module
ADD configs/patch.txt /tmp/patch.txt
RUN patch /usr/lib/python2.7/dist-packages/ansible/modules/extras/web_infrastructure/jira.py /tmp/patch.txt
# \ CDP-69 Patch Jira module

# / CDP-71 Forcing Supervisor to log as awx-user
RUN cp /etc/supervisor/supervisord.conf /etc/supervisor/supervisord.conf.bak \
    && sed -e'/^\[supervisord\]$/a user=awx' /etc/supervisor/supervisord.conf.bak > /etc/supervisor/supervisord.conf \
    && chown -R awx:awx /var/log/supervisor \
    && chown awx:awx /var/run
# \ CDP-71 Forcing Supervisor to log as awx-user


#Backuping generated live data because various sources should be injected externally
RUN echo "" \
    && echo "Caring about postgres-database, data, certs, settings, apache log, tower log" \
    && mv /var/lib/postgresql/9.4/main /var/lib/postgresql/9.4/main.bak \
    && mv /var/lib/awx /var/lib/awx.bak \
    && mv /etc/tower /etc/tower.bak \
    && mv /var/log/apache2 /var/log/apache2.bak \
    && mv /var/log/postgresql /var/log/postgresql.bak \
    && mv /var/log/supervisor /var/log/supervisor.bak \
    && mv /var/log/tower /var/log/tower.bak \
    && mv /var/log/redis /var/log/redis.bak
    
ADD scripts/docker-entrypoint.sh /docker-entrypoint.sh
ADD scripts/backup.sh /backup.sh
ADD scripts/restore.sh /restore.sh
RUN chmod +x /docker-entrypoint.sh /backup.sh /restore.sh

EXPOSE 443 11230

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]