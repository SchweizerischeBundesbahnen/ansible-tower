#!/bin/bash

tmpfile="/tmp/settings.xml"
destfile="/var/data/jenkins/m2/settings.xml"
backupfile="${destfile}.bak"

function downloadsettingsxml {
	echo "*** INFO *** : Try to download settins.xml from ${settingsxmlurl}"
	wget --no-check-certificate ${settingsxmlurl} -O ${tmpfile}
	checkRC
}

function checkRC {
  if [ $? -ne 0 ]; then
          echo "*** ERROR *** : Something went wrong"
          exit 1
  fi
}

function movetodest {
  if [ -s ${tmpfile} ]; then
	mv -v ${destfile} ${backupfile} && mv -v ${tmpfile} ${destfile}
	checkRC
  else
	echo "*** ERROR *** : File has a size of zero or does not exist"
	exit 1
  fi
}

downloadsettingsxml
movetodest
