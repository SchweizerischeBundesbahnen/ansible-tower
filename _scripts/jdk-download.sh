#!/bin/bash

##
# @author: Lukas Elsner
# @e-mail: lukas.elsner@sbb.ch
# @description: JDK auto downloader for Docker and EAIO
# @changelog: 2016-02-17: Initiated
##

DEPS=( "7z" "ant" "keytool" "curl" )
VERSIONS=( "$@" )
PLATFORMS=( "i586" "x64" )
OSS=( "linux" "windows" )
HEADER="Cookie: oraclelicense=accept-securebackup-cookie"
BUILDID="-1"
TMPDIR="/tmp/jdk-downloader"

BUILD=
PLATFORM=
VER=
OS=
DATADIR=

# use one of those
#CURLVERBOSITY=" -S -v "
CURLVERBOSITY=" -S "
#CURLVERBOSITY=" -s "

# webproxy.sbb.ch has problems with JDK download, use this as a workaround
#CURLPROXYWORKAROUND=" --socks5 localhost:60001"
CURLPROXYWORKAROUND=" --proxy http://fswzuad:bolb3fas@testwebproxy.sbb.ch:8080"

function error() {
  echo "Fatal: Could not finish operation. Exiting"
  exit 5
}

function find_build_id() {
  echo "Finding build number for ${version}, be patient please..."
  PLATFORM="${PLATFORMS[0]}"
  VER=$1
  OS="${OSS[0]}"
  for BUILD in {99..00}
  do
    BASE_URL="http://download.oracle.com/otn-pub/java/jdk/${VER}-b${BUILD}/"
    FILENAME="jdk-${VER}-${OS}-${PLATFORM}.tar.gz"
    curl -s -I -f -L -A "Mozilla/4.0" -b "oraclelicense=a" "${BASE_URL}${FILENAME}" -o /dev/null && {
    BUILDID=${BUILD}
    return
  }
  done
}

function download() {
  echo "Downloading ${FILENAME}"
  BASE_URL="http://download.oracle.com/otn-pub/java/jdk/${VER}-b${BUILD}/"
  curl ${CURLVERBOSITY} ${CURLPROXYWORKAROUND} --progress-bar -f -L -A "Mozilla/4.0" -b "oraclelicense=a" "${BASE_URL}${FILENAME}" -o $TMPDIR/"${FILENAME}" || error
}

function svn_upload() {
  echo "Importing ${FILENAME} to Subversion"
  svn import -m "Add $FILENAME" $TMPDIR/"${FILENAME}" https://svn.sbb.ch/svn/wzu/jdk/${FILENAME}
}

function nexus_upload() {
  if [[ ${OS} == "windows" ]]; then
    echo "Uploading artifact jdk-${VER}-${OS}-${PLATFORM}-sbb.zip to Nexus"
  else
    echo "Skipping upload of artifact jdk-${VER}-${OS}-${PLATFORM}-sbb.zip to Nexus"
    return
  fi
  ARTIFACT="oracle-jdk-$V-$P"
  curl --progress-bar -f \
 -F r=hosted.mwe-wzu.releases  \
 -F hasPom=false  \
 -F e=zip  \
 -F g=ch.sbb.eaio  \
 -F a=${ARTIFACT}  \
 -F v=${VER}  \
 -F p=zip  \
 -F file=@${TMPDIR}/"jdk-${VER}-${OS}-${PLATFORM}-sbb.zip" \
 -u admin:${ADMINPWD}  \
 http://repo.sbb.ch/service/local/artifact/maven/content || error
}

function unpack() {
  echo "Unpacking ${FILENAME}"

 if [[ ${VER:0:1} == "8" ]]; then
    V="1.8";
  else
    V="1.7";
  fi
  if [[ ${PLATFORM} == "x64" ]]; then
    P="64";
  else
    P="32";
  fi
  ZIPROOTDIR="${TMPDIR}/${FILENAME}-unpacked/"
  DATADIR="${ZIPROOTDIR}/jdk${V}_${P}/"
  mkdir -p ${DATADIR} || error

  if [ ${FORMAT} == "exe" ]; then
    7z e -bb0 -o${TMPDIR} ${TMPDIR}/${FILENAME} > /dev/null 2>&1  || error
    unzip -q ${TMPDIR}/tools.zip -d ${DATADIR} || error
    rm ${TMPDIR}/tools.zip
  else
    tar xzf ${TMPDIR}/${FILENAME} -C ${DATADIR} || error
  fi
}

function pack() {
  echo "Packing jdk-${VER}-${OS}-${PLATFORM}-sbb.zip"
  (cd ${ZIPROOTDIR} && zip -q -r $TMPDIR/"jdk-${VER}-${OS}-${PLATFORM}-sbb.zip" .) || error
}

function cleanup() {
  echo "Wiping the floor"
  rm -rf $TMPDIR
}

function add_cert() {
  echo "Adding Swisscon Certificates to keystores"
  curl ${CURLVERBOSITY} --progress-bar -f -L https://code.sbb.ch/projects/KD_WZU/repos/eaio/browse/cmdfiles/src/main/resources/import_cacerts.xml?raw  -o $TMPDIR/import_cacerts.xml || error
  ant -q -S -autoproxy -buildfile $TMPDIR/import_cacerts.xml -Dexecutable.keytool=`which keytool` -Dexecutable.wget=`which wget` -Dcertificates.dir=$TMPDIR/certs/ -Dinstall.root.dir=${DATADIR} || error
}

function usage() {
  echo -e "Download the oracle JDK from command line, uploads to svn, adds certificates and pushes to nexus, all unattended\n"
  echo -e "$0 [<versions>]\n"
  echo "  [<versions>] Something like 8u73 7u64"
  exit 1
}

function checkdeps() {
  EXIT=0
  for dep in ${DEPS[@]}
  do
    # @formatter:off
    command -v ${dep} > /dev/null 2>&1 || { echo >&2 "I require $dep but it's not installed."; EXIT=1; }
    # @formatter:on
  done
  [ ${EXIT} -eq 1 ] && echo "Dependencies not satisfied! Exiting." && exit 1
}

[ "$1" == "help" ] || [ "$#" -eq 0 ] && usage

checkdeps

mkdir -p $TMPDIR

for version in ${VERSIONS[@]}
do
  find_build_id $version
  echo "Got build number ${BUILDID}"
  [ $BUILDID -gt 100 ] && {
  echo "Build-Id not in range, exiting..."
  exit 1
}
  for platform in ${PLATFORMS[@]}
  do
    for os in ${OSS[@]}
    do
      BUILD=$BUILDID
      PLATFORM=$platform
      VER=$version
      OS=$os
      [ "$OS" == "windows" ] && FORMAT="exe" || FORMAT="tar.gz"
      FILENAME="jdk-${VER}-${OS}-${PLATFORM}.${FORMAT}"
      download
      svn_upload
      unpack
      add_cert
      pack
      nexus_upload
    done
  done
done
cleanup
echo "Done"
