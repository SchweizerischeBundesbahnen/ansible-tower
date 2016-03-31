FROM registry.sbb.ch/kd_wzu/datacontainers
MAINTAINER Pascal Bieri <pascal.bieri@sbb.ch>
ENV datadir /var/data
ENV appuser jira
ENV userhome /var/data/jira
ENV idoffset 20
RUN mkdir -p ${datadir} && adduser ${appuser} -U -u 10${idoffset} --home ${userhome}
VOLUME /var/data
User jira
#CMD ["tail", "-f","/dev/null"]
CMD ["echo", "Data container for JIRA"]
