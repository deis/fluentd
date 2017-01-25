SHORT_NAME ?= fluentd
BUILD_TAG ?= git-$(shell git rev-parse --short HEAD)
DEIS_REGISTRY ?= ${DEV_REGISTRY}
IMAGE_PREFIX ?= deis

include versioning.mk

build: docker-build
push: docker-push
install: kube-install
uninstall: kube-delete
upgrade: kube-update

docker-build:
	docker build ${DOCKER_BUILD_FLAGS} -t ${IMAGE} rootfs
	docker tag ${IMAGE} ${MUTABLE_IMAGE}

kube-delete:
	-kubectl delete -f manifests/deis-logger-fluentd-daemon.tmp.yaml

kube-install: update-manifests
	kubectl create -f manifests/deis-logger-fluentd-daemon.tmp.yaml

kube-update: update-manifests
	kubectl delete -f manifests/deis-logger-fluentd-daemon.tmp.yaml
	kubectl create -f manifests/deis-logger-fluentd-daemon.tmp.yaml

update-manifests:
	sed 's#\(image:\) .*#\1 $(IMAGE)#' manifests/deis-logger-fluentd-daemon.yaml > manifests/deis-logger-fluentd-daemon.tmp.yaml

test: docker-build
	docker run ${IMAGE} /bin/bash -c "cd /opt/fluentd/deis-output && rake test"
