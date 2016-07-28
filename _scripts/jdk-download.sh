#!/bin/bash

##
# @author: Lukas Elsner
# @e-mail: lukas.elsner@sbb.ch
# @description: JDK auto downloader for Docker and EAIO. This script fetches automatically Oracle JDKs from upstream,
#               uploads the files to SVN, extracts them, adds ccusto keystores, adds src.zip (copy from linux archive to windows archive),
#               and deploys them into nexus.
# @changelog: 2016-02-17: Initiated
##

DEPS=( "7z" "ant" "keytool" "curl" "which" )
VERSIONS=( "$@" )
PLATFORMS=( "i586" "x64" )
# Do linux first, because we need to cache the src.zip file from the archives (happens in unpack-method), to later on
# copy it to the windows archives.
OSS=( "linux" "windows" )

HEADER="Cookie: oraclelicense=accept-securebackup-cookie"
BUILDID="-1"
TMPDIR="/tmp/jdk-downloader"

BUILD=
PLATFORM=
VER=
OS=
DATADIR=
V=
P=

# use one of those
#CURLVERBOSITY=" -S -v "
#CURLVERBOSITY=" -S "
CURLVERBOSITY=" -s "

# webproxy.sbb.ch has problems with JDK download, use this as a workaround
CURLPROXYWORKAROUND=" --proxy http://fstools:${FSTOOLSPWD}@testwebproxy.sbb.ch:8080"

function error() {
  echo "Fatal: Could not finish operation. Exiting"
  exit 5
}

# Oracle appends a build-id to all releases. The only method to find the correct download url is, to try which one works.
# We start fromm 99 (assuming, this might be the maximum) and count downwards until we find a working download url. This
# then is the most recent build. (maybe). Takes some time and may break at any time. Thank you Oracle!
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

# Downlad the file. One could assume, that this is the most straight-forward task in this script, but the evil SBB-Proxy
# for sure does not try to make your life more beautiful...
function download() {
  echo "Downloading ${FILENAME}"
  BASE_URL="http://download.oracle.com/otn-pub/java/jdk/${VER}-b${BUILD}/"
  curl ${CURLVERBOSITY} ${CURLPROXYWORKAROUND} -f -L -A "Mozilla/4.0" -b "oraclelicense=a" "${BASE_URL}${FILENAME}" -o $TMPDIR/"${FILENAME}" || error
}

# Upload the downloaded file to SVN. This usually works and is furthermore fault tolerant, even when the file already exists.
function svn_upload() {
  echo "Importing ${FILENAME} to Subversion"
  svn import --username "fstools" --password ${FSTOOLSPWD} --non-interactive -m "Add $FILENAME" $TMPDIR/"${FILENAME}" https://svn.sbb.ch/svn/wzu/jdk/${FILENAME}
}

# Uploads the final results to nexus! If file was alredy uploaded, append revision-numbers (up ot 99),
# so that we do not overwrite (maybe we cannot at all) already existing releases.
function nexus_upload() {
  if [[ ${OS} == "windows" ]]; then
    echo "Uploading artifact jdk-${VER}-${OS}-${PLATFORM}-sbb.zip to Nexus"
  else
    echo "Skipping upload of artifact jdk-${VER}-${OS}-${PLATFORM}-sbb.zip to Nexus"
    return
  fi

  ARTIFACT="oracle-jdk-${V}-${P}"

  for REV in {01..99}
  do
      curl -f \
     -F r=hosted.mwe-wzu.releases  \
     -F hasPom=false  \
     -F e=zip  \
     -F g=ch.sbb.eaio  \
     -F a=${ARTIFACT}  \
     -F v=${VER}_r${REV}  \
     -F p=zip  \
     -F file=@${TMPDIR}/"jdk-${VER}-${OS}-${PLATFORM}-sbb.zip" \
     -u admin:${ADMINPWD}  \
     http://repo.sbb.ch/service/local/artifact/maven/content

    if [ $? -eq 0 ]
    then
      return
    else
      continue
    fi
  done
  error
}

# This method unpacks the Downloaded file (tgz for linux / exe for windows). Exe files seem to be unpackable with p7zip
# (might for sure change at any time). Oracle uses build and version numbers in several different formats. Thus we need
# some variables to satisfy all requirements:
# VER : commandline parameter (e.g.: 7u82, 8u101)
# V   : first char of $VER (e.g.: 7, 8)
# P   : short form of the PLATFORM item: (x64 == 64, i586 == 32)
# R   : revision Number extracted from $VER (7u82 -> 82, 8u201 -> 101)
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
  R=${VER:2}
  ZIPROOTDIR="${TMPDIR}/${FILENAME}-unpacked"
  DATADIR="${ZIPROOTDIR}/jdk${V}_${P}"
  mkdir -p ${DATADIR} || error

  if [ ${FORMAT} == "exe" ]; then
    7z e -y -o${TMPDIR} ${TMPDIR}/${FILENAME} > /dev/null 2>&1  || error
    unzip -q ${TMPDIR}/tools.zip -d ${DATADIR} || error
    rm ${TMPDIR}/tools.zip
    for file in $(find "${DATADIR}" -name "*pack"); do ${JAVA_HOME}/bin/unpack200 -r "${file}" "${file/%pack/jar}"; done
    cp ${TMPDIR}/src.zip ${DATADIR} || error
  else
    tar xzf ${TMPDIR}/${FILENAME} -C ${DATADIR} || error
    cp ${DATADIR}/jdk${V}.0_${R}/src.zip ${TMPDIR} || error
  fi
}


# Pack the modified JDK into a zip-file ready for uploading.
function pack() {
  echo "Packing jdk-${VER}-${OS}-${PLATFORM}-sbb.zip"
  (cd ${ZIPROOTDIR} && zip -q -r ${TMPDIR}/"jdk-${VER}-${OS}-${PLATFORM}-sbb.zip" .) || error
}

function cleanup() {
  echo "Wiping the floor"
  rm -rf $TMPDIR
}

# Adds some custom SBB-Certificates to the trust-chain.
function add_cert() {
  echo "Adding Swisscon Certificates to keystores"
  curl ${CURLVERBOSITY} -f -L https://code.sbb.ch/projects/KD_WZU/repos/eaio/browse/cmdfiles/src/main/resources/import_cacerts.xml?raw  -o $TMPDIR/import_cacerts.xml || error
  ant -q -S -autoproxy -buildfile $TMPDIR/import_cacerts.xml -Dexecutable.keytool=`which keytool` -Dexecutable.wget=`which wget` -Dcertificates.dir=$TMPDIR/certs/ -Dinstall.root.dir=${DATADIR} || error
}

function usage() {
  echo -e "Download the oracle JDK from command line, uploads to svn, adds certificates and pushes to nexus, all unattended\n"
  echo -e "$0 [<versions>]\n"
  echo "  [<versions>] Something like 8u77 7u80"
  exit 1
}

# Only run this script when all needed tools are already installed. Otherwise tell the user whats missing.
function checkdeps() {
  EXIT=0
  for dep in "${DEPS[@]}"
  do
    # @formatter:off
    command -v ${dep} > /dev/null 2>&1 || { echo >&2 "I require $dep but it's not installed."; EXIT=1; }
    # @formatter:on
  done
  [ ${EXIT} -eq 1 ] && echo "Dependencies not satisfied! Exiting." && exit 1
}

[ "$1" == "help" ] || [ "$#" -eq 0 ] && usage

checkdeps

# Wipe someone elses floor
[ -d ${TMPDIR} ] && cleanup

mkdir -p $TMPDIR

for version in "${VERSIONS[@]}"
do
  find_build_id ${version}
  echo "Got build number ${BUILDID}"
  [ ${BUILDID} -gt 100 ] && {
    echo "Build-Id not in range, exiting..."
    exit 1
  }
  for platform in "${PLATFORMS[@]}"
  do
    for os in "${OSS[@]}"
    do
      BUILD=${BUILDID}
      PLATFORM=${platform}
      VER=${version}
      OS=${os}
      [ "${OS}" == "windows" ] && FORMAT="exe" || FORMAT="tar.gz"
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
