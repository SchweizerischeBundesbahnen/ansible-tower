#!/bin/bash

# Check username is set
if [ -z "$USERNAME" ]; then
  echo "Username variable is not set."
  exit 1
fi

# Check if password is set
if [ -z "$PASSWORD" ]; then
  echo "Password variable is not set."
  exit 1
fi

# Set defaults
WORKING_DIRECTORY=/downloads
ARCHIVE_NAME=profiles

# Check if directory exists
if [ ! -d "$WORKING_DIRECTORY" ]; then
  echo "Download directory is not mounted. Creating directory ..."
  mkdir -p $WORKING_DIRECTORY
fi

# Check if Cupertino is installed
if ! ios_loc="$(command -v ios)" || [ -z "$ios_loc" ]; then
  echo "Installing latest Cupertino version ..."
  gem install cupertino
else
  echo "Updating Cupertino to latest version ..."
  gem update cupertino
fi

# Download new provisioning profiles with Cupertino
DOWNLOAD_FOLDER="$WORKING_DIRECTORY/$ARCHIVE_NAME"
mkdir -p $DOWNLOAD_FOLDER
cd $DOWNLOAD_FOLDER
echo "Downloading new provisioning profiles with Ruby version `ruby -v` and Cupertino version `ios --version` ..."
ios profiles:download:all -u ${USERNAME} -p ${PASSWORD} --trace --debug

# Check return code
if [ $? -ne 0 ]; then
  echo "**** Failure during download. ****"
  exit 1
fi

# Count and check new provisioning profiles
count=$(find . -maxdepth 1 -name '*.mobileprovision*' | wc -l | sed 's/^ *//')
if [ "$count" -gt "0" ]; then
  echo "**** Downloaded $count provisioning profiles. ****"
else
  echo "**** No provisioning profiles downloaded. ****"
  exit 1
fi

echo "Packing provisioning profiles into an archive ..."
ARCHIVE_FILENAME="$ARCHIVE_NAME.tar.gz"
cd $WORKING_DIRECTORY
tar cvzf $ARCHIVE_FILENAME ./$ARCHIVE_NAME

# Check if password is set
if [ -n "$URL" ]; then
  echo "Uploading archive $ARCHIVE_FILENAME to server $URL ..."
  curl -T $ARCHIVE_FILENAME $URL
fi

