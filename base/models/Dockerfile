#Docker image for jenkins master
FROM registry.sbb.ch/kd_wzu/base

MAINTAINER pascal.bieri@sbb.ch

# install/configure httpd php git
RUN yum install httpd php git  -y \
        && yum clean all
		
# Create Data directory
RUN      mkdir /var/www/models

#echo 'LoadModule dav_module modules/mod_dav.so
#LoadModule dav_fs_module modules/mod_dav_fs.so' > /etc/httpd/conf.d/dav.conf

RUN rm conf.d/welcome.conf

# expose port 22 for user
EXPOSE 80

# define some volumes
VOLUME /var/www/models

COPY conf/models.conf /etc/httpd/conf.d/models.conf
CMD ["httpd && tail -f /var/log/httpd/error_log"]

