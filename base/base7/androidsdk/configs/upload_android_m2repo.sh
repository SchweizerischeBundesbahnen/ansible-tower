#!/bin/bash
SOURCE_DIR=$1
REPO=$2
NEXUS_BASE_URL=http://${USERNAME}:${PASSWORD}@repo.sbb.ch
NEXUS_UNZIP_URL=$NEXUS_BASE_URL/service/local/repositories/$REPO/content-compressed
NEXUS_REPO_URL=$NEXUS_BASE_URL/content/repositories/$REPO

function createAndUploadAndroidRepoZip {
   cd $SOURCE_DIR/extras/android/m2repository \
   && zip -r $REPO-android.zip . \
   && curl --upload-file $REPO-android.zip $NEXUS_UNZIP_URL \
   && checkRC
}

function createAndUploadGoogleRepoZip {
   cd $SOURCE_DIR/extras/google/m2repository \
   && zip -r $REPO-google.zip . \
   && curl --upload-file ${REPO}-google.zip $NEXUS_UNZIP_URL \
   && checkRC
}

function checkRC {
  if [ $? -ne 0 ]; then
          echo "*** ERROR *** : Something went wrong"
          exit 1
  fi
}

function helpMe {
  echo "please give me the following parameters: Source, Reponame"
}

### start script
if [ ! -z $SOURCE_DIR ] && [ ! -z $REPO ] && [ ! -z $USERNAME ] && [ ! -z $PASSWORD ]; then
  echo "script started with following options: "
  echo "SOURCE_DIR: $SOURCE_DIR"
  echo "REPO: $REPO"
  echo "USERNAME: $USERNAME"

  ### start logic
  createAndUploadAndroidRepoZip
  createAndUploadGoogleRepoZip
else
  helpMe
fi