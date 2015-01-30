# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/base
MAINTAINER Christian Eichenberger <u214892@sbb.ch>

#Environment variables
ENV appversion 3.0.4
ENV appuser jrebellicense
ENV idoffset 150
ENV datadir /var/data
ENV apphome /var/data/jrebellicenseserver
ENV PATH /usr/local/bin:/sbin:/usr/sbin:/usr/bin:/bin


# Create Data directory structure and add user jira to the image
RUN mkdir -p ${datadir}/ && adduser ${appuser} -U -u 10${idoffset} --home ${apphome} && mkdir -p ${apphome}/license-server


# Get the license-server
RUN cd /opt && wget -q "http://dl.zeroturnaround.com/license-server/license-server-${appversion}.zip"  -O license-server-${appversion}.zip && unzip license-server-${appversion}.zip && rm license-server-${appversion}.zip 


# Start the license server in ${apphome}
CMD /opt/jdk/bin/java -Dhttp.port=8${idoffset} -Drebel.ls.loglevel=ERROR -Drebel.ls.logfile=${apphome}/logs/license-server.log -Drebel.ls.dataDir=${apphome}/data -jar /opt/license-server/lib/license-server.jar >> ${apphome}/logs/license-server.out 2>&1

