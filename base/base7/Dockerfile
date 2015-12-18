# This is the base Dockerfile for all SBB Dockerfiles @WZU
FROM schweizerischebundesbahnen/base

MAINTAINER Roger Bobst <roger.bobst@sbb.ch>

ENV jdkurl ${filerurl}/jdk/jdk-7u79-linux-x64.tar.gz

# Get and Install Java
RUN echo ${jdkurl} && curl -s ${jdkurl} -o /opt/jdk.tar.gz \
	&& cd /opt && tar xfz jdk.tar.gz \
	&& ln -s /opt/jdk1.7* ${JAVA_HOME} \
	&& rm -rf /opt/*.tar.gz \
	&& /opt/jdk/bin/java -version

# Install WZU Keystore
RUN wget --quiet ${filerurl}/${keystore} -O /opt/jdk/jre/lib/security/cacerts
