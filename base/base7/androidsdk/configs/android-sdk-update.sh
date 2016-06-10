#!/bin/bash

# -----------------------------------------------------------------------------
# Android SDK Update script
# -----------------------------------------------------------------------------

# Get Android SDK home
if [ -z "$1" ]; then
  if [ -z "$ANDROID_HOME" ]; then
    echo "Enviromnet variable ANDROID_HOME is not set."
    exit 1
  fi
else
  ANDROID_HOME=$1
fi

EXECUTABLE=android
PRGDIR="$ANDROID_HOME"/tools

if [ ! -x "$PRGDIR"/"$EXECUTABLE" ]; then
  echo "Cannot find $PRGDIR/$EXECUTABLE"
  echo "The file is absent or does not have execute permission"
  echo "This file is needed to run this program"
  exit 1
fi

export PATH=$PATH:$PRGDIR:$ANDROID_HOME/platform-tools

# List all available packages
android list sdk --all --extended
expect -c '
set timeout -1;
# / MWESERVICE-10986
spawn android update sdk --no-ui --all --filter tool,platform-tool,platform,build-tools-23.0.3,build-tools-23.0.1,build-tools-22.0.1,build-tools-21.1.2,build-tools-20.0.0,build-tools-19.1.0,sys-img-x86_64-android-23,sys-img-x86-android-23,sys-img-x86_64-android-22,sys-img-x86-android-22,sys-img-x86_64-android-21,sys-img-x86-android-21,sys-img-x86-android-19,sys-img-x86-android-18,sys-img-x86-android-17,sys-img-x86-android-16,sys-img-x86-android-15,extra-google-m2repository,extra-android-m2repository,extra-android-support,extra-google-google_play_services,extra-google-play_apk_expansion,extra-google-play_billing,extra-google-webdriver
#spawn android update sdk --no-ui --all --filter tools,platform-tools,build-tools-23.0.3,build-tools-23.0.1,build-tools-22.0.1,build-tools-21.1.2,build-tools-20.0.0,build-tools-19.1.0,android-23,android-22,android-21,android-20,android-19,android-18,android-17,android-16,android-15,android-14,sys-img-x86_64-android-23,sys-img-x86-android-23,sys-img-x86_64-android-22,sys-img-x86-android-22,sys-img-x86_64-android-21,sys-img-x86-android-21,sys-img-x86-android-19,sys-img-x86-android-18,sys-img-x86-android-17,sys-img-x86-android-16,sys-img-x86-android-15,extra-google-m2repository,extra-android-m2repository,extra-android-support,extra-google-google_play_services,extra-google-play_apk_expansion,extra-google-play_billing,extra-google-webdriver
# \ MWESERVICE-10986

expect {
  "Do you accept the license" { exp_send "y\r" ; exp_continue }
  eof
}
'
