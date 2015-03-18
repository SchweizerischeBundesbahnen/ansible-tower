#! /bin/bash

export appversion=3.0.4
export appuser=jrebellicense
export idoffset=150
export datadir=/var/data
export apphome=/var/data/jrebellicenseserver
export PATH=/usr/local/bin:/sbin:/usr/sbin:/usr/bin:/bin


# Create Data directory structure and add user jira to the image
mkdir -p ${datadir}/ && adduser ${appuser} -U -u 10${idoffset} --home ${apphome} && mkdir -p ${apphome}/license-server


# Get the license-server
cd /opt && wget -q "http://dl.zeroturnaround.com/license-server/license-server-${appversion}.zip"  -O license-server-${appversion}.zip && unzip license-server-${appversion}.zip && rm license-server-${appversion}.zip