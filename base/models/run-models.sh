#!/bin/bash
wget --quiet https://svn.sbb.ch/svn/wzu/models/index.php --user ${fileruser} --password ${filerpassword} --no-check-certificate -O /var/www/models/index.php
wget --quiet https://svn.sbb.ch/svn/wzu/models/styles.css --user ${fileruser} --password ${filerpassword} --no-check-certificate -O /var/www/models/styles.css
wget --quiet https://svn.sbb.ch/svn/wzu/models/sbb.png --user ${fileruser} --password ${filerpassword} --no-check-certificate -O /var/www/models/sbb.png
rm -rf /run/httpd/* /tmp/httpd*
chown -R apache:apache /var/www/models
exec /usr/sbin/apachectl -DFOREGROUND
