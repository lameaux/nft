GO_HTTPSERVER_IMAGE := ghcr.io/lameaux/nft/apps/golang/httpserver

.PHONY: all
all: docker-build-apps

.PHONY: docker-build-apps
docker-build-apps:
	docker build -t $(GO_HTTPSERVER_IMAGE) ./golang/httpserver