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

EXPOSE 22
EXPOSE 9080

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
