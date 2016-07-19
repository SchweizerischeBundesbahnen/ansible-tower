FROM fedora:latest
MAINTAINER Pascal Bieri <pascal.bieri@sbb.ch>

RUN yum install -y -q https://twindb.com/twindb-release-latest.noarch.rpm

RUN yum install -y -q \
	git \
	which \
  mydumper \
  duplicity \
  mysql \
  && yum clean all -q

# Set locale to en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN echo "export LC_ALL=en_US.UTF-8" > /etc/profile.d/lang.sh

# Set TZ variable
ENV TZ Europe/Zurich

# Change timezone to Europe/Zurich
RUN ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

COPY configs/wzu_backup.sh /var/wzu_backup.sh
RUN git clone https://code.sbb.ch/scm/kd_wzu/wzu-backup.git
CMD /var/wzu_backup.sh