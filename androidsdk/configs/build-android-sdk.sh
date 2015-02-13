# Get android sdk
wget ${filerurl}/android-sdk.tar.gz -O /tmp/android-sdk.tar.gz \
        && mkdir ${jenkinshome}/buildtools \
        && cd ${jenkinshome}/buildtools \
        && tar xfz /tmp/android-sdk.tar.gz \
        && rm -f /tmp/android-sdk.tar.gz \
        && cd ${jenkinshome}/buildtools/android-sdk-linux \
        && wget ${filerurl}/android-sdk-update.sh -O android-sdk-update.sh \
        && chmod +x ./android-sdk-update.sh \
        && chown -R ${appuser}:${appuser} ${jenkinshome}

# Update android sdk
su - ${appuser} -c "export ANDROID_HOME=${jenkinshome}/buildtools/android-sdk-linux JAVA_HOME=/opt/jdk && PATH=$PATH:/opt/jdk/bin && ${jenkinshome}/buildtools/android-sdk-linux/android-sdk-update.sh"

# compress to tarball
tar -zcf /output/android-sdk-linux-latest.tar.gz /output/buildtools

# upload to wzufiler
curl -T /output/android-sdk-linux-latest.tar.gz http://wzufiler.sbb.ch/android/
