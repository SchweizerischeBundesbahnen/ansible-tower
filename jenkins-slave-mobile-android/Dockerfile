# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM schweizerischebundesbahnen/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV labels "swarm android"

# Install qemu and kvm
RUN yum install -q qemu-kvm qemu-kvm-tools -y && yum clean all -q

# Get android sdk from wzufiler
RUN cd ${jenkinshome}/buildtools \
	&& wget -qO- ${filerurl}/android/android-sdk-linux-latest.tar.gz | tar xfz - \
	&& mv output/buildtools/android-sdk-linux . \
	&& rm -rf output \
        && chown -R ${appuser}:${appuser} ${jenkinshome}

# Add ANDROID_HOME to environment 
RUN echo "export ANDROID_HOME=${jenkinshome}/buildtools/android-sdk-linux" >> ${jenkinshome}/env.sh

# Workaround for zipalign includign fix for multiple buikld-tools versions
RUN ln -sf `find ${jenkinshome}/buildtools/android-sdk-linux -name zipalign | tail -n 1` ${jenkinshome}/buildtools/android-sdk-linux/tools/zipalign

# Run jenkins
CMD echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive"
