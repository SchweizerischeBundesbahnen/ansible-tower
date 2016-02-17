#!/bin/bash

##
# @author: Lukas Elsner
# @e-mail: lukas.elsner@sbb.ch
# @description: JDK auto downloader for Docker and EAIO
# @changelog: 2016-02-17: Initiated
##

VERSIONS=( "$@" )
PLATFORMS=( "i586" "x64" )
OSS=( "linux" "windows" )
HEADER="Cookie: oraclelicense=accept-securebackup-cookie"
BUILDID="-1"
TMPDIR="/tmp"

BUILD=
PLATFORM=
VER=
OS=
DATADIR=

function find_build_id() {
    PLATFORM="${PLATFORMS[0]}"
    VER=$1
    OS="${OSS[0]}"
    for BUILD in {99..00}
    do
        BASE_URL="http://download.oracle.com/otn-pub/java/jdk/${VER}-b${BUILD}/"
        FILENAME="jdk-${VER}-${OS}-${PLATFORM}.tar.gz"
        wget -q --spider -c -O /dev/null --show-progress --no-check-certificate --no-cookies --header "${HEADER}" "${BASE_URL}${FILENAME}" && {
        BUILDID=${BUILD}
        return
    }
    done
}

function download() {
    BASE_URL="http://download.oracle.com/otn-pub/java/jdk/${VER}-b${BUILD}/"
    wget -c --show-progress -O $TMPDIR/"${FILENAME}" --no-check-certificate --no-cookies --header "${HEADER}" "${BASE_URL}${FILENAME}"
}

function svn_upload() {
    svn import -m "Add $FILENAME" $TMPDIR/"${FILENAME}" https://svn.sbb.ch/svn/wzu/jdk/${FILENAME}
}

function nexus_upload() {
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
    B=${VER:2:2}
    ARTIFACT="oracle-jdk-$V-$P"
    VERSION="$V.0_$B"
    curl -v  \
 -F r=hosted.mwe-wzu.releases \
 -F hasPom=false  \
 -F e=zip  \
 -F g=ch.sbb.eaio  \
 -F a=$ARTIFACT  \
 -F v=$VERSION  \
 -F p=zip  \
 -F file=@${TMPDIR}/${FILENAME}  \
 -u admin:$ADMINPWD  \
 http://repo.sbb.ch/service/local/artifact/maven/content
}

function unpack() {
    DATADIR="${TMPDIR}/${FILENAME}-unpacked"
    mkdir -p ${DATADIR}

    if [ $FORMAT == "exe" ]; then
        7z e -o$TMPDIR ${TMPDIR}/${FILENAME}
        unzip $TMPDIR/tools.zip -d $DATADIR
        rm $TMPDIR/tools.zip
    else
        tar xzvf ${TMPDIR}/${FILENAME} -C $DATADIR
    fi
}

function pack() {
    (cd $DATADIR && zip -r $TMPDIR/"jdk-${VER}-${OS}-${PLATFORM}-sbb.zip" .)
}

function add_cert() {
    wget https://code.sbb.ch/projects/KD_WZU/repos/eaio/browse/cmdfiles/src/main/resources/import_cacerts.xml?raw -O $TMPDIR/import_cacerts.xml
    ant -autoproxy -buildfile $TMPDIR/import_cacerts.xml -Dexecutable.keytool=keytool -Dexecutable.wget=wget
}

function usage() {
    echo -e "Download the oracle JDK from command line, uploads to svn, adds certificates and pushes to nexus, all unattended\n"
    echo -e "$0 [<versions>]\n"
    echo "  [<versions>] Something like 8u73 7u64"
    exit 1
}

[ "$1" == "help" ] || [ "$#" -eq 0 ] && usage

for version in ${VERSIONS[@]}
do
    echo "Finding build number for ${version}"
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
