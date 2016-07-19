FROM fedora:latest
MAINTAINER Pascal Bieri <pascal.bieri@sbb.ch>

RUN rpm import https://copr-be.cloud.fedoraproject.org/results/nibbler/mydumper/pubkey.gpg
RUN dnf install 'dnf-command(config-manager)'
RUN dnf config-manager --add-repo https://copr-be.cloud.fedoraproject.org/results/nibbler/mydumper/
RUN dnf install -y -q \
  https://twindb.com/twindb-release-latest.noarch.rpm \
	git \
	which \
  mydumper \
  duplicity \
  mysql \
  && dnf clean all -q

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