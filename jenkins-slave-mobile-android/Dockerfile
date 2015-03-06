# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV gradle1version 1.12
ENV labels "swarm android"

# Install qemu and kvm
RUN yum install -q qemu-kvm qemu-kvm-tools -y && yum clean all -q

# Get android sdk from wzufiler
RUN wget --quiet ${filerurl}/android/android-sdk-linux-latest.tar.gz -O /tmp/android-sdk-linux-latest.tar.gz \
	&& cd ${jenkinshome}/buildtools \
	&& tar -zxf /tmp/android-sdk-linux-latest.tar.gz \
	&& rm /tmp/android-sdk-linux-latest.tar.gz \
	&& mv output/buildtools/android-sdk-linux . \
	&& chown -R ${appuser}:${appuser} ${jenkinshome}

# Download Gradle 1
RUN wget --quiet "https://services.gradle.org/distributions/gradle-${gradle1version}-bin.zip" -O /tmp/gradle-${gradle1version}-bin.zip \
	&& cd ${jenkinshome}/buildtools \
	&& unzip -q /tmp/gradle-${gradle1version}-bin.zip \
	&& rm -f /tmp/gradle-${gradle1version}-bin.zip \
	&& ln -s ${jenkinshome}/buildtools/gradle-${gradle1version} ${jenkinshome}/buildtools/gradle-1

# Add ANDROID_HOME to environment 
RUN echo "export ANDROID_HOME=${jenkinshome}/buildtools/android-sdk-linux" >> ${jenkinshome}/env.sh

# Add android-tools path to PATH
RUN echo 'export PATH=$PATH:'${jenkinshome}/buildtools/android-sdk-linux/tools:${jenkinshome}/buildtools/gradle-1/bin >> ${jenkinshome}/env.sh

# Workaround for zipalign
RUN ln -sf ${jenkinshome}/buildtools/android-sdk-linux/build-tools/2*/zipalign ${jenkinshome}/buildtools/android-sdk-linux/tools/zipalign

# Run jenkins
CMD echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive"
