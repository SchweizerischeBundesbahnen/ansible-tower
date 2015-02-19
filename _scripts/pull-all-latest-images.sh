images=`docker images | grep -v REPOSITORY | cut -d" " -f1 | sort | uniq`

for image in $images; do sudo docker pull $image; done
