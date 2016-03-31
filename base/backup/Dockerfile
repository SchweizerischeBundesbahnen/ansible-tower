FROM registry.sbb.ch/kd_wzu/base
MAINTAINER Pascal Bieri <pascal.bieri@sbb.ch>

RUN yum install -y -q https://twindb.com/twindb-release-latest.noarch.rpm

RUN yum install -y -q \
	git \
	which \
    mydumper \
    duplicity \
    && yum clean all -q

COPY configs/wzu_backup.sh /var/wzu_backup.sh
RUN git clone https://code.sbb.ch/scm/kd_wzu/wzu-backup.git
RUN ln -sf /dev/stdout /var/log/duplicity-backup.log
CMD /var/wzu_backup.sh
