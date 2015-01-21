mkdir -p /var/data/docker/conf
mkdir -p /var/data/docker/index
mkdir -p /var/data/docker/storage

sudo docker run -d -e GUNICORN_OPTS=[--preload] \
  -e SETTINGS_FLAVOR=dev \
  -e SEARCH_BACKEND=sqlalchemy \
  -e DOCKER_REGISTRY_CONFIG=/registry-conf/config.yml \
  -v /var/data/docker/conf:/registry-conf -v /var/data/docker/storage:/tmp/registry \
  -v /var/data/docker/index:/tmp/index \
  -p 5000:5000 \
  --name registry \
  registry
