FROM centos:centos6.6
MAINTAINER Igor Masen <igor.masen@sbb.ch>

ENV name git
ENV version 1.8.5.5
ENV HOME /root

VOLUME /output

# update and install rpmbuild-tools
RUN yum update -q -y && \
    yum install -q -y tar wget curl-devel expat-devel gettext-devel openssl-devel zlib-devel git curl make yum-utils rpmdev-setuptree rpmdevtools rpm-build xmlto asciidoc perl-ExtUtils-MakeMaker gcc

# create directory structure for rpm-build
RUN mkdir -p /output ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS} ~/src

# create the script for building git
COPY configs/build-git-rpm.sh /root/ 

# build the rpm on container start
CMD /bin/bash ~/build-git-rpm.sh
