# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM registry.sbb.ch/kd_wzu/base8
MAINTAINER Christian Eichenberger <u214892@sbb.ch>

#Environment variables
ENV appuser intellijlicense
ENV idoffset 180
ENV datadir /var/data
ENV apphome /var/data/intellijlicenseserver
ENV PATH /usr/local/bin:/sbin:/usr/sbin:/usr/bin:/bin
EXPOSE 8${idoffset}

# Create Data directory structure and add appuser to the image
RUN mkdir -p ${datadir}/ && adduser ${appuser} -U -u 10${idoffset} --home ${apphome} && mkdir -p ${apphome}/.jb-license-server

# Get the license-server
RUN cd /opt \
    && mkdir license-server \
    && cd license-server \
    && wget -q "https://download.jetbrains.com/lcsrv/license-server-installer.zip"  -O license-server-installer.zip\
    && unzip license-server-installer.zip && rm license-server-installer.zip

# copy configs to installation dir
COPY configs/service-config.properties /opt/license-server/conf/service-config.properties
COPY configs/intellijlicenseserver.sh /opt/license-server/bin/wzu-license-server.sh
RUN chown -R 10${idoffset}:10${idoffset} /opt/license-server && chmod u+x /opt/license-server/bin/wzu-license-server.sh

# copy configs to appuser home
COPY configs/server-config.xml ${apphome}/.jb-license-server/server-config.xml
RUN chown -R 10${idoffset}:10${idoffset} ${apphome}

# Start the license server
USER ${appuser}
# Sanity check à la Igorova:
RUN /opt/license-server/bin/license-server.sh help
CMD export proxy_host=${proxy_host} && export proxy_port=${proxy_host} && proxy_user=${proxy_user} && proxy_password=${proxy_password} && /opt/license-server/bin/wzu-license-server.sh
