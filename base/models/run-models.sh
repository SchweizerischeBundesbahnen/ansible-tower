#!/bin/bash
wget --quiet https://svn.sbb.ch/svn/wzu/models/index.php --user ${fileruser} --password ${filerpassword} --no-check-certificate -O /var/www/models/index.php
wget --quiet https://svn.sbb.ch/svn/wzu/models/styles.css --user ${fileruser} --password ${filerpassword} --no-check-certificate -O /var/www/models/styles.css
rm -rf /run/httpd/* /tmp/httpd*
exec /usr/sbin/apachectl -DFOREGROUND
