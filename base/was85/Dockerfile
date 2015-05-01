FROM schweizerischebundesbahnen/base
MAINTAINER Christoph Glanzmann <christoph.glanzmann@sbb.ch>

ENV filerurl http://wzufiler.sbb.ch/was85.tar.gz
ENV scripturl http://wzufiler.sbb.ch/me.tar.gz
ENV appuser asrun

# Create directories and add user to the image
RUN adduser ${appuser} \
	&& echo "${appuser}:${appuser}" | chpasswd \
	&& mkdir /home/${appuser}/.ssh

# Add public key for passwordless login 
COPY configs/authorized_keys /home/${appuser}/.ssh/authorized_keys

# Download and extract WAS 8.5 and create profile
RUN cd /opt \
        && curl ${filerurl} | tar xfz - \
        && chown -R ${appuser}:${appuser} was85

# Download and extract OM managements scripts
RUN cd / \
        && curl ${scripturl} | tar xfz - \
        && cd /opt \
        && chown -R ${appuser}:${appuser} me

# Add scripts
COPY configs/run.sh /opt/run.sh
RUN chmod +x /opt/run.sh

# Add sshd
RUN yum install openssh-server openssh-clients -y \
	&& yum clean all \
	&& /usr/bin/ssh-keygen -A

# Add supervisor configuration
COPY configs/was85.ini /etc/supervisor/conf.d/
COPY configs/sshd.ini /etc/supervisor/conf.d/

RUN mkdir -pv /opt/source/delivery \
        && chown ${appuser}:${appuser} /opt/source \
        && chown ${appuser}:${appuser} /opt/source/delivery

#SSH,SOAP_CONNECTOR_ADDRESS,SIP_DEFAULTHOST_SECURE,SIP_DEFAULTHOST,SIB_ENDPOINT_ADDRESS,WC_defaulthost_secure,DCS_UNICAST_ADDRESS
#SIB_MQ_ENDPOINT_SECURE_ADDRESS,WC_adminhost_secure,CSIV2_SSL_MUTUALAUTH_LISTENER_ADDRESS,ORB_LISTENER_ADDRESS,
#BOOTSTRAP_ADDRESS,CSIV2_SSL_SERVERAUTH_LISTENER_ADDRESS,IPC_CONNECTOR_ADDRESS,SIB_ENDPOINT_SECURE_ADDRESS,WC_defaulthost,
#SIB_MQ_ENDPOINT_ADDRESS,SAS_SSL_SERVERAUTH_LISTENER_ADDRESS,OVERLAY_UDP_LISTENER_ADDRESS,OVERLAY_TCP_LISTENER_ADDRESS,WC_adminhost
EXPOSE 22 8880 5061 5060 7276 9443 9353 5578 9043 9402 9100 2809 9403 9633 7286 9080 5558 9401 11003 11004 9060

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
