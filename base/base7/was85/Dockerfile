FROM schweizerischebundesbahnen/base7
MAINTAINER Christoph Glanzmann <christoph.glanzmann@sbb.ch>

ENV scripturl http://wzufiler.sbb.ch/me.tar.gz
ENV appuser asrun
ENV profileName AppSrv01

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

RUN /opt/was85/bin/managesdk.sh -setNewProfileDefault -sdkName 1.7_64 \
        && /opt/was85/bin/manageprofiles.sh -create -templatePath /opt/was85/profileTemplates/default \
                -profileName ${profileName} -profilePath /opt/was85/profiles/${profileName} -isDefault

RUN mkdir -pv /opt/source/delivery \
        && chown ${appuser}:${appuser} /opt/source \
        && chown ${appuser}:${appuser} /opt/source/delivery \
        && chown -R ${appuser}:${appuser} /opt/was85 \
        && chown -R ${appuser}:${appuser} /opt/was85_shared

# Add the files for the installation in unmanaged WAS (=developer edition) using the postdev ..
COPY configs/ant_task_lib.patch /opt/me/res/ant/ant_task_lib.patch
RUN cd /opt/me/res/jython && \
      curl https://code.sbb.ch/projects/KD_WZU/repos/eaio/browse/hotdeploy/src/main/resources/scripts/jython/postdev_general.py?raw -o postdev_general.py && \
      curl https://code.sbb.ch/projects/KD_WZU/repos/eaio/browse/hotdeploy/src/main/resources/scripts/jython/predev_general.py?raw -o predev_general.py && \
      curl https://code.sbb.ch/projects/KD_WZU/repos/eaio/browse/hotdeploy/src/main/resources/om.profile/jython/devbase.py?raw -o devbase.py && \
# ... and patch ant_task_lib.xml with dev additions
      cd /opt/me/res/ant && \
      cp ant_task_lib.xml ant_task_lib.xml.orig && \
      head -n $(expr $(grep -n "</project>" ant_task_lib.xml | sed -e 's$\(.*\):</project>$\1$') - 1 ) ant_task_lib.xml > ant_task_lib.xml.new && \
      cat ant_task_lib.patch >> ant_task_lib.xml.new && \
      echo "</project>" >> ant_task_lib.xml.new && \
      mv ant_task_lib.xml.new ant_task_lib.xml && \
      chown -R ${appuser}:${appuser} * && \
# ... and builder.sh
      sed -i 's%WAS_BIN=.*%WAS_BIN=$ROOT/AppSrv01/bin%g' /opt/me/bin/builder.sh


#SSH,SOAP_CONNECTOR_ADDRESS,SIP_DEFAULTHOST_SECURE,SIP_DEFAULTHOST,SIB_ENDPOINT_ADDRESS,WC_defaulthost_secure,DCS_UNICAST_ADDRESS
#SIB_MQ_ENDPOINT_SECURE_ADDRESS,WC_adminhost_secure,CSIV2_SSL_MUTUALAUTH_LISTENER_ADDRESS,ORB_LISTENER_ADDRESS,
#BOOTSTRAP_ADDRESS,CSIV2_SSL_SERVERAUTH_LISTENER_ADDRESS,IPC_CONNECTOR_ADDRESS,SIB_ENDPOINT_SECURE_ADDRESS,WC_defaulthost,
#SIB_MQ_ENDPOINT_ADDRESS,SAS_SSL_SERVERAUTH_LISTENER_ADDRESS,OVERLAY_UDP_LISTENER_ADDRESS,OVERLAY_TCP_LISTENER_ADDRESS,WC_adminhost
EXPOSE 22 8880 5061 5060 7276 9443 9353 5578 9043 9402 9100 2809 9403 9633 7286 9080 5558 9401 11003 11004 9060

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]



