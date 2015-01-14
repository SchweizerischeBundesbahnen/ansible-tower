sudo docker run \
  -d \
  -e ENV_DOCKER_REGISTRY_HOST=registry-t.sbb.ch \
  -e ENV_DOCKER_REGISTRY_PORT=5000 \
  -p 8081:80 \
  konradkleine/docker-registry-frontend
