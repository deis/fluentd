SHORT_NAME ?= fluentd
BUILD_TAG ?= git-$(shell git rev-parse --short HEAD)
DEIS_REGISTRY ?= ${DEV_REGISTRY}/
IMAGE_PREFIX ?= deisci
IMAGE := ${DEIS_REGISTRY}${IMAGE_PREFIX}/${SHORT_NAME}:${BUILD_TAG}

info:
	@echo "Build tag:  ${BUILD_TAG}"
	@echo "Registry:   ${DEIS_REGISTRY}"
	@echo "Image:      ${IMAGE}"

docker-build: build
	docker build --rm -t ${IMAGE}

docker-push:
	docker push ${IMAGE}

kube-delete:
	-kubectl delete -f manifests/deis-logger-rc.yaml
	-kubectl delete -f manifests/deis-logger-svc.yaml
	-kubectl delete -f manifests/deis-logger-fluentd-daemon.tmp.yaml

kube-create: update-manifests
	kubectl create -f manifests/deis-logger-rc.yaml
	kubectl create -f manifests/deis-logger-svc.yaml
	kubectl create -f manifests/deis-logger-fluentd-daemon.tmp.yaml

kube-replace: build push update-manifests
	kubectl replace --force -f manifests/deis-logger-rc.yaml
	kubectl replace --force -f manifests/deis-logger-svc.yaml
	kubectl replace --force -f manifests/deis-logger-fluentd-daemon.tmp.yaml

update-manifests:
	sed 's#\(image:\) .*#\1 $(IMAGE)#' manifests/deis-logger-fluentd-daemon.yaml > manifests/deis-logger-fluentd-daemon.tmp.yaml
	sed 's#\(image:\) .*#\1 $(IMAGE)#' manifests/deis-logger-fluentd-daemon.yaml > manifests/deis-logger-fluentd-daemon.tmp.yaml
