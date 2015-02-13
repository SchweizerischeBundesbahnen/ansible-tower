FROM schweizerischebundesbahnen/base
MAINTAINER Roger Bobst <roger.bobst@sbb.ch>

ENV HOME /root
ENV filerurl http://wzufiler.sbb.ch
ENV jenkinshome /output
ENV appuser jenkins
ENV portoffset 91

VOLUME /output

RUN yum install -q qemu-kvm qemu-kvm-tools expect python-lxml git subversion glibc.i686 libgcc.i686 xmlstarlet graphviz mingw32 mingw32-nsis gtk2.i686 xorg-x11-server-Xvfb redhat-lsb xmlstarlet expect -y && yum clean all -q 

RUN adduser ${appuser} -U -u 10${portoffset} --home ${jenkinshome} && echo "${appuser}:${appuser}" | chpasswd

# create the script for building git
COPY configs/build-android-sdk.sh /root/

# build the rpm on container start
CMD /bin/bash ~/build-android-sdk.sh

