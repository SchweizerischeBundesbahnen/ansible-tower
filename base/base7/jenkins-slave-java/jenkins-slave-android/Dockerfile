# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM registry.sbb.ch/kd_wzu/jenkins-slave-java
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV gradle2version 2.5
ENV labels "android java"
ENV ANDROID_HOME ${jenkinshome}/buildtools/android-sdk-linux

# Install qemu and kvm
RUN yum install -q qemu-kvm qemu-kvm-tools npm -y && yum clean all -q

# Get android sdk and Gradle from wzufiler
RUN cd ${jenkinshome}/buildtools \
	&& wget -q ${filerurl}/android/android-sdk-linux-latest.tar.gz \
	&& md5sum android-sdk-linux-latest.tar.gz \
	&& tar xfz android-sdk-linux-latest.tar.gz \
	&& mv output/buildtools/android-sdk-linux . \
	&& rm -rf output android-sdk-linux-latest.tar.gz \
# Download Gradle
    && wget --quiet "https://services.gradle.org/distributions/gradle-${gradle2version}-bin.zip" -O /tmp/gradle-${gradle2version}-bin.zip \
	&& cd ${jenkinshome}/buildtools \
	&& unzip -q /tmp/gradle-${gradle2version}-bin.zip \
	&& rm -f /tmp/gradle-${gradle2version}-bin.zip \
	&& ln -s ${jenkinshome}/buildtools/gradle-${gradle2version} ${jenkinshome}/buildtools/gradle \
	&& mkdir -p ${jenkinshome}/.gradle \
	&& mkdir -p ${jenkinshome}/.codequality \
	&& chown -R ${appuser}:${appuser} ${jenkinshome}

# Add gradle.properties
COPY configs/* ${jenkinshome}/.gradle/

# Add ANDROID_HOME to environment 
RUN echo "export ANDROID_HOME=${jenkinshome}/buildtools/android-sdk-linux" >> ${jenkinshome}/env.sh

# Workaround for zipalign includign fix for multiple buikld-tools versions
RUN ln -sf `find ${jenkinshome}/buildtools/android-sdk-linux -name zipalign | tail -n 1` ${jenkinshome}/buildtools/android-sdk-linux/tools/zipalign

# Run jenkins
CMD \
# / OTM-63 Build mit Android Emulator funktioniert nicht\
         su - ${appuser} -c "source ${jenkinshome}/env.sh ${jenkinshome}/buildtools/android-sdk-linux/tools/android list target \
		 && ( echo no | ${jenkinshome}/buildtools/android-sdk-linux/tools/android create avd -f -a -c 512M -s WVGA800 -n hudson_de-CH_160_WVGA_android-19_x86 -t android-19 --abi x86) \
		 && ${jenkinshome}/buildtools/android-sdk-linux/platform-tools/adb start-server \
		 && (${jenkinshome}/buildtools/android-sdk-linux/tools/emulator -no-boot-anim -ports 5608,5609 -prop persist.sys.language=de -prop persist.sys.country=CH -avd hudson_de-CH_160_WVGA_android-19_x86 -no-snapshot-load -no-snapshot-save -no-window -qemu -m 2047 -enable-kvm &)"\
		 && sleep 30 \
 		 && su - ${appuser} -c "source ${jenkinshome}/env.sh ${jenkinshome}/buildtools/android-sdk-linux/tools/adb devices" \
# \ OTM-63 Build mit Android Emulator funktioniert nicht\
         && echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive -noRetryAfterConnected -retry 1 -disableClientsUniqueId"

