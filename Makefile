SHORT_NAME ?= fluentd
BUILD_TAG ?= git-$(shell git rev-parse --short HEAD)
DEIS_REGISTRY ?= ${DEV_REGISTRY}
IMAGE_PREFIX ?= deis

include versioning.mk

build: docker-build
push: docker-push

docker-build:
	docker build ${DOCKER_BUILD_FLAGS} -t ${IMAGE} rootfs
	docker tag ${IMAGE} ${MUTABLE_IMAGE}

test: docker-build
	docker run ${IMAGE} /bin/bash -c "cd /opt/fluentd/deis-output && rake test"

install:
	helm upgrade fluentd charts/fluentd --install --namespace deis --set org=${IMAGE_PREFIX},docker_tag=${VERSION}

upgrade:
	helm upgrade fluentd charts/fluentd --namespace deis --set org=${IMAGE_PREFIX},docker_tag=${VERSION}

uninstall:
	helm delete fluentd --purge