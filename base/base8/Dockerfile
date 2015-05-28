# This is the base Dockerfile for all SBB Dockerfiles @WZU
FROM schweizerischebundesbahnen/base 

MAINTAINER Roger Bobst <roger.bobst@sbb.ch>

jdkurl http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz 

# Get and Install Java
RUN curl -Lks --header "Cookie: oraclelicense=accept-securebackup-cookie" ${jdkurl} -o /opt/jdk.tar.gz \
	&& cd /opt && tar xfz jdk.tar.gz \
	&& ln -s /opt/jdk1.8* ${JAVA_HOME} \
	&& rm -rf /opt/*.tar.gz

# Install WZU Keystore
RUN wget --quiet http://wzufiler.sbb.ch/keystore -O /opt/jdk/jre/lib/security/cacerts
