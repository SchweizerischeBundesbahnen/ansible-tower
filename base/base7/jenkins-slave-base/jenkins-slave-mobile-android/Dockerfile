# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM registry.sbb.ch/kd_wzu/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV gradle2version 2.5
ENV labels "swarm android"
ENV ANDROID_HOME ${jenkinshome}/buildtools/android-sdk-linux

# Install qemu and kvm
RUN yum install -q qemu-kvm qemu-kvm-tools -y && yum clean all -q

# Get android sdk and Gradle from wzufiler
RUN cd ${jenkinshome}/buildtools \
	&& wget -q ${filerurl}/android/android-sdk-linux-latest.tar.gz \
	&& md5sum android-sdk-linux-latest.tar.gz \
	&& tar xfz android-sdk-linux-latest.tar.gz \
	&& mv output/buildtools/android-sdk-linux . \
	&& rm -rf output android-sdk-linux-latest.tar.gz \
	&& chown -R ${appuser}:${appuser} ${jenkinshome}/m2  ${jenkinshome}/temp  ${jenkinshome}/workspace \
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
COPY configs/* ${jenkinshome}/.codequality/

# Add ANDROID_HOME to environment 
RUN echo "export ANDROID_HOME=${jenkinshome}/buildtools/android-sdk-linux" >> ${jenkinshome}/env.sh

# Workaround for zipalign includign fix for multiple buikld-tools versions
RUN ln -sf `find ${jenkinshome}/buildtools/android-sdk-linux -name zipalign | tail -n 1` ${jenkinshome}/buildtools/android-sdk-linux/tools/zipalign

# Run jenkins
CMD echo "set -e; export jenkinshome=${jenkinshome} master=${master}" > ${jenkinshome}/.codequality/android2.sh && cat ${jenkinshome}/.codequality/android.sh >> ${jenkinshome}/.codequality/android2.sh && chown ${appuser}:${appuser} "${jenkinshome}/.codequality/android2.sh" && \
#su - ${appuser} -c "${jenkinshome}/.codequality/android2.sh" && \
echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive"

