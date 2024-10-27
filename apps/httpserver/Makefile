DOCKER_REPO := ghcr.io
DOCKER_IMAGE := lameaux/nft/apps/httpserver
DOCKER_BUILD := docker buildx build --platform linux/amd64,linux/arm64

GOLANG_STDLIB_IMAGE := $(DOCKER_REPO)/$(DOCKER_IMAGE)/golang/stdlib:latest
NETTY_IMAGE := $(DOCKER_REPO)/$(DOCKER_IMAGE)/java/netty:latest
QUARKUS_IMAGE := $(DOCKER_REPO)/$(DOCKER_IMAGE)/java/quarkus:latest
RUST_AXUM_IMAGE := $(DOCKER_REPO)/$(DOCKER_IMAGE)/rust/axum:latest

.PHONY: all
all: docker-release-apps

.PHONY: docker-release-apps
docker-release-apps: docker-release-apps-golang
#docker-release-apps: docker-release-apps-java
#docker-release-apps: docker-release-apps-rust

.PHONY: docker-release-apps-golang
docker-release-apps-golang:
	$(DOCKER_BUILD) -t $(GOLANG_STDLIB_IMAGE) ./golang/stdlib
	docker push $(GOLANG_STDLIB_IMAGE)

.PHONY: docker-release-apps-java
docker-release-apps-java:
	$(DOCKER_BUILD) -t $(NETTY_IMAGE) ./java/netty
	docker push $(NETTY_IMAGE)

	$(DOCKER_BUILD) -t $(QUARKUS_IMAGE) ./java/quarkus
	docker push $(QUARKUS_IMAGE)

.PHONY: docker-release-apps-rust
docker-release-apps-rust:
	$(DOCKER_BUILD) -t $(RUST_AXUM_IMAGE) ./rust/axum
	docker push $(RUST_AXUM_IMAGE)
