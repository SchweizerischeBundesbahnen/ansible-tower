# Ansible Tower Dockerfie

FROM ubuntu:14.04
#Image based on https://github.com/ybalt/ansible-tower 
MAINTAINER sebastian.graf@sbb.ch

ENV ANSIBLE_TOWER_VER 2.4.5
ENV DATA /external/data
ENV LOGS /external/logs
ENV SETTINGS /external/settings
ENV GIT_SSL_NO_VERIFY 1

RUN apt-get update \
    && apt-get install -y software-properties-common wget \
    && apt-add-repository -y ppa:ansible/ansible \
    && apt-get update \
    && apt-get install -y ansible \
    && apt-get clean

ADD http://releases.ansible.com/awx/setup/ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz /opt/ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz

RUN cd /opt && tar -xvf ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz \
    && rm -rf ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz \
    && mv ansible-tower-setup-${ANSIBLE_TOWER_VER} /opt/tower-setup \
    && ls /opt/tower-setup

ADD configs/tower_setup_conf.yml /opt/tower-setup/tower_setup_conf.yml
ADD configs/inventory /opt/tower-setup/inventory

RUN cd /opt/tower-setup \
    && ./setup.sh \
    && ansible-tower-service stop
    
#Backuping generated live data because various sources should be injected externally
RUN echo "Caring about postgres-database" \
    && mv /var/lib/postgresql/9.4/main /var/lib/postgresql/9.4/main.bak \
    && ln -sf ${DATA}/postgres /var/lib/postgresql/9.4/main \
    && echo "Caring about tower-data" \
    && mv /var/lib/awx /var/lib/awx.bak \
    && ln -sf ${DATA}/awx /var/lib/awx \
    && echo "Caring about ssl-certs" \
    && mv /etc/tower/tower.cert /etc/tower/tower.cert.bak \
    && ln -sf ${SETTINGS}/certs/deploy.sbb.ch_cer.pem /etc/tower/tower.cert \
    && mv /etc/tower/tower.key /etc/tower/tower.key.bak \
    && ln -sf ${SETTINGS}/certs/deploy.sbb.ch_privatekey.pem /etc/tower/tower.key \
    && echo "Caring about license, no bak needed because not existing in fresh installation" \
    && ln -sf ${SETTINGS}/license /etc/tower/license \
    && echo "Caring about settings.py" \
    && mv /etc/tower/settings.py /etc/tower/settings.py.bak \
    && ln -sf ${SETTINGS}/settings.py /etc/tower/settings.py \
    && echo "Caring about ldap.py" \
    && mv /etc/tower/conf.d/ldap.py /etc/tower/conf.d/ldap.py.bak \
    && ln -sf ${SETTINGS}/ldap.py /etc/tower/conf.d/ldap.py \
    && echo "Caring about log files" \
    && mkdir -p ${LOGS}/apache2 \
    && ln -sf ${LOGS}/apache2/error.log /var/log/apache2/error.log \
    && ln -sf ${LOGS}/apache2/access.log /var/log/apache2/access.log \
    && ln -sf ${LOGS}/apache2/other_vhosts_access.log /var/log/apache2/other_vhosts_access.log \
    && mkdir -p ${LOGS}/tower \
    && ln -sf ${LOGS}/tower/callback_receiver.log /var/log/tower/callback_receiver.log \
    && ln -sf ${LOGS}/tower/fact_receiver.log /var/log/tower/fact_receiver.log \
    && ln -sf ${LOGS}/tower/socketio_service.log /var/log/tower/socketio_service.log \
    && ln -sf ${LOGS}/tower/task_system.log /var/log/tower/task_system.log \
    && ln -sf ${LOGS}/tower/tower.log /var/log/tower/tower.log
    
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 443 11230

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["ansible-tower"]