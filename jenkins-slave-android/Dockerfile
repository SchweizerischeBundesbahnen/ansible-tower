# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM jenkins-slave-jee
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

# Remove the fat WAS
RUN rm -rf ${jenkinshome}/buildtools/was70 && rm -rf ${jenkinshome}/buildtools/was85

# Get android sdk
RUN wget --quiet ${filerurl}/android-sdk.tar.gz -O /tmp/android-sdk.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/android-sdk.tar.gz && cd ${jenkinshome}/buildtools/android-sdk-linux && wget --quiet ${filerurl}/android-sdk-update.sh -O android-sdk-update.sh && chmod +x ./android-sdk-update.sh && chown -R ${appuser}:${appuser} ${jenkinshome}

# Update android sdk
RUN su - jenkins -c "export ANDROID_HOME=${jenkinshome}/buildtools/android-sdk-linux JAVA_HOME=/opt/jdk17 && ${jenkinshome}/buildtools/android-sdk-linux/android-sdk-update.sh"

