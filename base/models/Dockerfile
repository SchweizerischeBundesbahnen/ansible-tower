#Docker image for Models Publishing
FROM registry.sbb.ch/kd_wzu/base
MAINTAINER pascal.bieri@sbb.ch

# install/configure httpd php git
RUN yum install httpd php git  -y \
        && yum clean all
		
# Create Data directory
RUN mkdir /var/www/models && chown apache:apache /var/www/models

# Remove defaultpage
RUN rm /etc/httpd/conf.d/welcome.conf

# expose port 80 for apache
EXPOSE 8170

# define some volumes
VOLUME /var/www/models

# Copy httpdconfig for models on port 8170
COPY config/models.conf /etc/httpd/conf.d/models.conf

# Copy startupscript and Chmod
COPY run-models.sh /run-models.sh 
RUN  chmod -v +x /run-models.sh

# Run startupscript
CMD ["/run-models.sh"]
