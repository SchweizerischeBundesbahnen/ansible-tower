# Get android sdk, definition from develop of wzu-docker
mkdir -p ${jenkinshome}/buildtools \
	&& cd ${jenkinshome}/buildtools \
	&& wget -qO- ${filerurl}/android-sdk.tar.gz | tar xfz - \
	&& cd ${jenkinshome}/buildtools/android-sdk-linux \
    && wget -q https://code.sbb.ch/projects/KD_WZU/repos/wzu-docker/browse/base/base7/androidsdk/configs/android-sdk-update.sh?raw -O android-sdk-update.sh \
    && chmod +x ./android-sdk-update.sh \

# Update android sdk
export ANDROID_HOME=${jenkinshome}/buildtools/android-sdk-linux JAVA_HOME=/opt/jdk && PATH=$PATH:/opt/jdk/bin && ${jenkinshome}/buildtools/android-sdk-linux/android-sdk-update.sh

# compress to tarball
tar -zcf /output/android-sdk-linux-latest.tar.gz /output/buildtools

# create md5sum for log
md5sum /output/android-sdk-linux-latest.tar.gz

# delete file from filerurl
svn delete --non-interactive --no-auth-cache --username ${fileruser} --password ${filerpassword} -m "Deleting file android-sdk-linux-latest.tar.gz from build" ${filerurl}/android/android-sdk-linux-latest.tar.gz

# upload to wzufiler
svn import --non-interactive --no-auth-cache --username ${fileruser} --password ${filerpassword} -m "Updating android-sdk-linux-latest.tar.gz from build" /output/android-sdk-linux-latest.tar.gz ${filerurl}/android/android-sdk-linux-latest.tar.gz
