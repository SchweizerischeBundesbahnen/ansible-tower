FROM registry.sbb.ch/kd_wzu/datacontainers
MAINTAINER Christian Eichenberger <u214892@sbb.ch>

ENV appuser jrebellicense
ENV idoffset 150
ENV datadir /var/data
ENV apphome /var/data/jrebellicenseserver

RUN mkdir -p ${datadir} && adduser ${appuser} -U -u 10${idoffset} --home ${apphome} && mkdir -p ${apphome}/data && mkdir -p ${apphome}/logs

VOLUME /var/data
USER ${appuser}
CMD ls -al ${apphome} && curl --insecure https://fsvctip:sommer11@svn.sbb.ch/svn/wzu/${ZIPNAME} -o /var/data/jrebellicenseserver/data/${ZIPNAME} && echo "Data container for JRebel License Primary"
