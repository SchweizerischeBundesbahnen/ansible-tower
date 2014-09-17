# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV labels "swarm android"

# Get android sdk
RUN wget --quiet ${filerurl}/android-sdk.tar.gz -O /tmp/android-sdk.tar.gz && cd ${jenkinshome}/buildtools && tar xfz /tmp/android-sdk.tar.gz && rm -f /tmp/android-sdk.tar.gz && cd ${jenkinshome}/buildtools/android-sdk-linux && wget --quiet ${filerurl}/android-sdk-update.sh -O android-sdk-update.sh && chmod +x ./android-sdk-update.sh && chown -R ${appuser}:${appuser} ${jenkinshome}

# Update android sdk
RUN su - jenkins -c "export ANDROID_HOME=${jenkinshome}/buildtools/android-sdk-linux JAVA_HOME=/opt/jdk17 && ${jenkinshome}/buildtools/android-sdk-linux/android-sdk-update.sh"

# Add ANDROID_HOME to environment 
RUN echo "export ANDROID_HOME=${jenkinshome}/buildtools/android-sdk-linux" >> ${jenkinshome}/env.sh

# Add android-tools path to PATH
RUN echo 'export PATH=$PATH:'${jenkinshome}/buildtools/android-sdk-linux/tools >> ${jenkinshome}/env.sh

# Workaround for zipalign
RUN ln -sf ${jenkinshome}/buildtools/android-sdk-linux/build-tools/20.0.0/zipalign ${jenkinshome}/buildtools/android-sdk-linux/tools/zipalign

# Run jenkins
CMD /root/run.sh && su - jenkins -c "source ${jenkinshome}/env.sh && /opt/jdk17/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive"
