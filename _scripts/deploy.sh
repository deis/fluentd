#!/usr/bin/env bash
#
# Build and push Docker images to Docker Hub and quay.io.
#

cd "$(dirname "$0")" || exit 1

export BUILD_TAG=v2-alpha
echo "Logging into docker hub account!"
docker login -e="$DOCKER_EMAIL" -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
echo "Building docker image and pushing to docker hub!"
docker build -t deisci/fluentd:$VERSION ..
docker push deisci/fluentd:$VERSION
echo "Logging into quay.io account!"
docker login -e="$QUAY_EMAIL" -u="$QUAY_USERNAME" -p="$QUAY_PASSWORD" quay.io
echo "Building docker image and pushing to quay.io!"
docker build -t quay.io/deisci/fluentd:$VERSION
docker push quay.io/deisci/fluentd:$VERSION
