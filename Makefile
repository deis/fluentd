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
	docker build -t ${IMAGE} .
	docker tag -f ${IMAGE} ${MUTABLE_IMAGE}

kube-delete:
	-kubectl delete -f manifests/deis-logger-fluentd-daemon.tmp.yaml

kube-create: update-manifests
	kubectl create -f manifests/deis-logger-fluentd-daemon.tmp.yaml

kube-update: update-manifests
	kubectl delete -f manifests/deis-logger-fluentd-daemon.tmp.yaml
	kubectl create -f manifests/deis-logger-fluentd-daemon.tmp.yaml

update-manifests:
	sed 's#\(image:\) .*#\1 $(IMAGE)#' manifests/deis-logger-fluentd-daemon.yaml > manifests/deis-logger-fluentd-daemon.tmp.yaml
