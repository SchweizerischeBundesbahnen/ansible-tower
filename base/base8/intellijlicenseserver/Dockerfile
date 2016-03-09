# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM registry.sbb.ch/kd_wzu/base8
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
RUN mkdir -p ${datadir}/ && adduser ${appuser} -U -u 10${idoffset} --home ${apphome}

# Get the license-server
RUN cd /opt
    && mkdir license-server
    && cd license-server
    && wget -q "https://download.jetbrains.com/lcsrv/license-server-installer.zip"  -O license-server-installer.zip
    && unzip license-server-installer.zip && rm license-server-installer.zip
    && chown -R 10${idoffset}:10${idoffset} /opt/license-server
    &&  su - ${appuser} -c "/opt/license-server/bin/license-server.sh help"

COPY configs/service-config.properties /opt/license-server/conf/service-config.properties
RUN chown 10${idoffset}:10${idoffset} /opt/license-server/conf/service-config.properties

# Start the license server
CMD  export JAVA_HOME=/opt/jdk && /opt/license-server/bin/license-server.sh configure --https.proxyUser ${fileruser} --http.proxyUser ${fileruser} --https.proxyPassword ${filerpassword} --http.proxyPassword ${filerpassword} --port 8${idoffset} --listen ${appdomain} && /opt/license-server/bin/license-server.sh run