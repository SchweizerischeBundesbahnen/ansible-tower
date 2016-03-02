FROM registry.sbb.ch/kd_wzu/base
 
MAINTAINER igor.masen@sbb.ch

ENV user backup

# install/configure sshd
RUN yum install openssh-server openssh-clients rsync -y \
	&& yum clean all \
	&& /usr/bin/ssh-keygen -A

 
# Create Data directory structure and add user to the image
RUN adduser ${user} -U -u 1000 --home /home/${user} \
	&& usermod -a -G wheel ${user} \
	&& mkdir -p /var/backup /home/${user}/.ssh

# copy public keys 
COPY configs/authorized_keys /home/${user}/.ssh/authorized_keys
	
# install supervisor
RUN yum update -y \
	&& yum -y install python-setuptools \
	&& yum clean all -q \
	&& easy_install supervisor \
	&& mkdir -p /etc/supervisor/conf.d

# setting up locale
RUN echo "LC_ALL=en_US.UTF-8" >> /home/${user}/.bashrc
 
# expose port 22 for user
EXPOSE 22

# define some volumes
VOLUME /var/backup

# supervisord: configure
COPY configs/supervisord.conf /etc/supervisor/supervisord.conf
COPY configs/sshd.ini /etc/supervisor/conf.d/

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
