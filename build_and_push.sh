#!/bin/bash
# Buildea y sube todas las imágenes a Docker Hub.
# Uso: ./build_and_push.sh <dockerhub_user> <ruta_al_repo_IOT>
#
# Ejemplo:
#   ./build_and_push.sh miusuario ../IOT-repo

set -e

DOCKER_USER=${1:?"Uso: $0 <dockerhub_user> <ruta_repo_IOT>"}
REPO_PATH=${2:?"Uso: $0 <dockerhub_user> <ruta_repo_IOT>"}
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

echo "→ Login en Docker Hub"
docker login

echo "→ Build y push: api"
docker build -t "$DOCKER_USER/iot-api:latest" "$REPO_PATH/services/api"
docker push "$DOCKER_USER/iot-api:latest"

echo "→ Build y push: worker_post"
docker build -t "$DOCKER_USER/iot-worker-post:latest" "$REPO_PATH/services/worker_post"
docker push "$DOCKER_USER/iot-worker-post:latest"

echo "→ Build y push: worker_delete"
docker build -t "$DOCKER_USER/iot-worker-delete:latest" "$REPO_PATH/services/worker_delete"
docker push "$DOCKER_USER/iot-worker-delete:latest"

echo "→ Build y push: haproxy-balancer"
docker build \
  -f "$SCRIPT_DIR/Dockerfile.haproxy" \
  -t "$DOCKER_USER/iot-balancer:latest" \
  "$SCRIPT_DIR"
docker push "$DOCKER_USER/iot-balancer:latest"

echo ""
echo " Imágenes publicadas:"
echo "  $DOCKER_USER/iot-api:latest"
echo "  $DOCKER_USER/iot-worker-post:latest"
echo "  $DOCKER_USER/iot-worker-delete:latest"
echo "  $DOCKER_USER/iot-balancer:latest"
echo ""
echo "Ahora edita variables.tf y añade:"
echo "  variable \"docker_user\" { default = \"$DOCKER_USER\" }"
