#Docker image for jenkins master
FROM registry.sbb.ch/kd_wzu/base
 
MAINTAINER roger.bobst@sbb.ch

# install/configure sshd
RUN yum install openssh-server openssh-clients -y \
	&& yum clean all \
	&& /usr/bin/ssh-keygen -A

 
# Create Data directory structure and add user sshuser to the image
RUN adduser sshuser -U -u 1000 --home /home/sshuser \
	&& usermod -a -G wheel sshuser \
	&& echo "sshuser:sshuser" | chpasswd \
	&& mkdir -p /var/data

# install supervisor
RUN yum update -y \
	&& yum -y install python-setuptools \
	&& yum clean all -q \
	&& easy_install supervisor \
	&& mkdir -p /etc/supervisor/conf.d

# setting up locale
RUN echo "LC_ALL=en_US.UTF-8" >> /home/sshuser/.bashrc
 
# expose port 22 for user
EXPOSE 22

# define some volumes
VOLUME /var/data
VOLUME /opt

# supervisord: configure
COPY configs/sshd.ini /etc/supervisor/conf.d/

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
