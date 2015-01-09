FROM centos:centos6
MAINTAINER Igor Masen <igor.masen@sbb.ch>

ENV gitversion 1.8.5.5

VOLUME /output

# update and install rpmbuild-tools
RUN yum update -y \
    && yum install -q curl-devel expat-devel gettext-devel openssl-devel zlib-devel git curl make yum-utils rpmdev-setuptree rpmdevtools rpm-build

# create directory structure for rpm-build
RUN mkdir -p ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}

# clone git-repository
RUN cd ~/src && git clone https://github.com/git/git.git && git checkout tags/${gitversion}

# tar the git code and move to SOURCES
RUN tar cfz git-${gitversion}.tar.gz git && mv git-${gitversion}.tar.gz ~/rpmbuild/SOURCES

# build the rpm
RUN ~/src/git && ls | grep *.spec
rpmbuild -ba git.spec
