# ansible-tower
Ansible Tower dockerized. This image is based on https://github.com/ybalt/ansible-tower.

## Build

The Image is build by travis-ci and pushed automatically to Dockerhub. Unfornatunaly due to the installation method ending up in a running http-instance, Dockerhub is not able to build this image. Therefore we are force to use travis-ci.

* https://hub.docker.com/r/schweizerischebundesbahnen/ansible-tower/
* https://travis-ci.org/SchweizerischeBundesbahnen/ansible-tower

### Tagging Schema

* latest-dev: Built feature-branch, everything but master
* latest: Latest build on master
* TAG: Build of git-tag, lastest also references to this build 

## Run

Mounts for settings (/etc/tower), postgres (/var/lib/postgresql/9.4/main), data (/var/lib/awx) and logs (/var/log/apache2, /var/log/postgresql, /var/log/supervisor, /var/log/tower) must exist. Otherwise, the image won't start.

### /var/lib/postgresql/9.4/main

* Mount for PostgresDB
* bootstrapable with "docker-compose ansible-tower run intialize", if folder and /var/lib/awx leer are empty

### /var/lib/awx

* Mount for awx-data
* bootstrapable with "docker-compose ansible-tower run intialize", if folder and /var/lib/postgresql/9.4/main leer are empty

### /etc/tower

* settings, must be present and can not be bootstrapped
* conf.d/ha.py is going to be copied within "initialize"-command, since its ID mus be in sync with the DB 

### /var/log/apache2, /var/log/postgresql, /var/log/supervisor, /var/log/tower

* mounts für logs
* can be empty


## Start of the ansible-towers

* docker and docker-compose must be present
* /etc/tower mus be present externally

1. Clonen of settings-repo containing /etc/tower
e.g. within SBB-network
```
git clone https://code.sbb.ch/scm/~u217229/deploy-t-instance.git
```

2. At the first start: bootstrap
```
cd deploy-t-instance
docker-compose ansible-tower run intialize
```

3. start of the tower
```
cd deploy-t-instance
docker-compose ansible-tower up -d
```

[Optional] Setting the admin-Password
```
docker exec -it deploytinstance_ansible-tower_1 tower-manage changepassword admin
```

[Optional] Backup 

Backups are written to mounted "/backup"-Mount
```
docker exec -it ANSIBLEINSTANCE ./backup.sh
```

[Optional] Restore 

Restore need a tower-backup-latest.tar.gz in "/backup"-Mount. /var/lib/awx and /var/lib/postgresql/9.4/main must be empty. Tower must be stopped.
```
docker-compose run ansible-tower ./restore.sh
```

## Outline of this repo

## ./configs

Configs for building the tower, like inventory for the installation and patched.

##  ./scripts
scripts like entrypoint, backup and restore

## Dockerfile, Readme, License

WYSIWYG