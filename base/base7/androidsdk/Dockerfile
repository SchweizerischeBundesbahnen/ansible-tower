FROM schweizerischebundesbahnen/base7
MAINTAINER Roger Bobst <roger.bobst@sbb.ch>

ENV HOME /root
ENV jenkinshome /output
ENV appuser jenkins
ENV portoffset 91

VOLUME /output

# Install dependencies
RUN yum install -q qemu-kvm qemu-kvm-tools python-lxml glibc.i686 libgcc.i686 xmlstarlet graphviz mingw32 mingw32-nsis gtk2.i686 xorg-x11-server-Xvfb redhat-lsb xmlstarlet expect -y && yum clean all -q

# Create user
RUN adduser ${appuser} -U -u 10${portoffset} --home ${jenkinshome} && echo "${appuser}:${appuser}" | chpasswd

# create the script for building git
COPY configs/build-android-sdk.sh /root/

# add the script for upload m2 repo
COPY configs/upload_android_m2repo.sh /root/upload_android_m2repo.sh

# build the rpm on container start
CMD /bin/bash ~/build-android-sdk.sh; /bin/bash ~/upload_android_m2repo.sh /output/buildtools hosted.android.releases
