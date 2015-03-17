Docker Container for downloading Apple Xcode Provisioning Profiles
==================================================================

Generate a Gemfile.lock
-----------------------
    docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app ruby:2.1 bundle install

See Docker Hub for more information. https://registry.hub.docker.com/u/library/ruby/

Create Docker Image
-------------------
    sudo docker build -t schweizerischebundesbahnen/cupertino .

Downloading Profiles
--------------------

Download provisioning profiles to mounted directory
    sudo docker run -e USERNAME="mwe@sbb.ch" -e PASSWORD="******" -v ~/downloads:/downloads schweizerischebundesbahnen/cupertino

Upload archived provisioning profiles to server
    sudo docker run -e USERNAME="mwe@sbb.ch" -e PASSWORD="*****" -e URL="http://wzufiler.sbb.ch/ios/" schweizerischebundesbahnen/cupertino
