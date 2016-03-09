# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM registry.sbb.ch/kd_wzu/base7
MAINTAINER Christian Eichenberger <u214892@sbb.ch>

#Environment variables
ENV appuser intellijlicense
ENV idoffset 180
ENV datadir /var/data
ENV apphome /var/data/intellijlicenseserver
ENV PATH /usr/local/bin:/sbin:/usr/sbin:/usr/bin:/bin
ENV appdomain intellij-license.sbb.ch
EXPOSE 8${idoffset}

# Create Data directory structure and add user jira to the image
RUN mkdir -p ${datadir}/ && adduser ${appuser} -U -u 10${idoffset} --home ${apphome} && mkdir -p ${apphome}/license-server

# Get the license-server
RUN cd /opt && mkdir license-server && cd license-server && wget -q "https://download.jetbrains.com/lcsrv/license-server-installer.zip"  -O license-server-installer.zip && unzip license-server-installer.zip && rm license-server-installer.zip && find /opt/license-server

COPY configs/service-config.properties /opt/license-server/conf/service-config.properties

# Start the license server in ${apphome}
CMD /bin/bash -c "sleep 500"
#/opt/license-server/bin/license-server.sh configure --port 8${idoffset} --listen ${appdomain}
