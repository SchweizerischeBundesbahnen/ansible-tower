#@FIXME muss auf datacontainers zeigen
FROM registry.sbb.ch/kd_wzu/base
MAINTAINER Pascal Bieri <pascal.bieri@sbb.ch>
ENV datadir /var/data
ENV appuser confluence
ENV userhome /var/data/confluence
ENV idoffset 40
RUN mkdir -p ${datadir} && adduser ${appuser} -U -u 10${idoffset} --home ${userhome}
VOLUME /var/data
User confluence
#CMD ["tail", "-f","/dev/null"]
CMD ["echo", "Data container for Confluence"]
