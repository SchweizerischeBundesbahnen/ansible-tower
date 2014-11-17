#Base Image for atlassian products in WZU
#Leaned on https://bitbucket.org/atlassianlabs/atlassian-docker/ > base
FROM schweizerischebundesbahnen/base

MAINTAINER Sebastian Graf <sebastian.graf@sbb.ch>

# get java
RUN curl -Lks --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz -o /opt/jdk17.tar.gz && cd /opt && tar xfz jdk17.tar.gz && ln -s /opt/jdk1.7* /opt/jdk && rm -rf /opt/*.tar.gz

RUN /usr/sbin/groupadd atlassian
