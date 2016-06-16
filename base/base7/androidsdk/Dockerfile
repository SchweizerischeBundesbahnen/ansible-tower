FROM registry.sbb.ch/kd_wzu/base7
MAINTAINER Roger Bobst <roger.bobst@sbb.ch>

ENV HOME /root
ENV jenkinshome /output
ENV USERNAME replacemeatruntime
ENV PASSWORD replacemeatruntime

# Install dependencies
RUN yum install -q expect -y && yum clean all -q

# create the script for building git
COPY configs/build-android-sdk.sh /root/

# add the script for upload m2 repo
COPY configs/upload_android_m2repo.sh /root/

# update the android archive in svn on container start (configuration is taken from develop of wzu-docker)
CMD /bin/bash ~/build-android-sdk.sh; /bin/bash ~/upload_android_m2repo.sh /output/buildtools/android-sdk-linux hosted.android.releases
