# Ansible Tower Dockerfie

FROM ubuntu:14.04
#Image based on https://github.com/ybalt/ansible-tower 
MAINTAINER sebastian.graf@sbb.ch

ENV ANSIBLE_TOWER_VER 2.4.5
ENV DATA /external/data
ENV SETTINGS /external/settings
ENV LOGS /external/logs
ENV GIT_SSL_NO_VERIFY 1

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

ADD configs/tower_setup_conf.yml /opt/tower-setup/tower_setup_conf.yml
ADD configs/inventory /opt/tower-setup/inventory

RUN cd /opt/tower-setup \
    && ./setup.sh \
    && ansible-tower-service stop

# / CDP-69 Patch Jira module
ADD configs/patch.txt /tmp/patch.txt
RUN patch /usr/lib/python2.7/dist-packages/ansible/modules/extras/web_infrastructure/jira.py /tmp/patch.txt
# \ CDP-69 Patch Jira module

# Adding predefined settings in Image
ADD bootstrap/ /tmp/bootstrap

#Backuping generated live data because various sources should be injected externally
RUN echo "" \
    && echo "Caring about postgres-database" \
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
    && echo "Caring about remote_host_headers.py" \
    && mv /etc/tower/conf.d/remote_host_headers.py /etc/tower/conf.d/remote_host_headers.py.bak \
    && ln -sf ${SETTINGS}/remote_host_headers.py /etc/tower/conf.d/remote_host_headers.py \
    && echo "Caring about apache log files" \
    && 
    && mv /var/log/apache2 /var/log/apache2.bak \
    && ln -sf ${LOGS}/apache2/ /var/log/ \
    && echo "Caring about tower log files" \
    && mv /var/log/tower /var/log/tower.bak \
    && ln -sf ${LOGS}/tower/ /var/log/
    
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 443 11230

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["ansible-tower"]