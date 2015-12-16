# cleanup first
sudo docker stop sshvm
sudo docker rm sshvm
sudo docker rmi registry.sbb.ch/sshvm


# build
sudo docker build --rm -t registry.sbb.ch/sshvm .

# run
sudo docker run -p 10022:22 -p 10080:80 -d --name sshvm registry.sbb.ch/sshvm

# run with external volumes
sudo docker run -p 10022:22 -p 10080:80 -v /local/data/dir:/var/data -d --name sshvm registry.sbb.ch/sshvm
