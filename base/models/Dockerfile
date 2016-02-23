#Docker image for jenkins master
FROM registry.sbb.ch/kd_wzu/base

MAINTAINER pascal.bieri@sbb.ch

# install/configure httpd php git
RUN yum install httpd php git  -y \
        && yum clean all
		
# Create Data directory
RUN mkdir /var/www/models && chown apache:apache /var/www/models

RUN rm /etc/httpd/conf.d/welcome.conf

# expose port 80 for user
EXPOSE 80

# define some volumes
VOLUME /var/www/models
# Copy httpdconfig for models
COPY config/models.conf /etc/httpd/conf.d/models.conf
#CMD ["httpd", "&&", "sleep 1", "&&", "tail", "-f", "/var/log/httpd/error_log"]
COPY run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh
CMD ["/run-httpd.sh"]
