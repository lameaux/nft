GOLANG_IMAGE := ghcr.io/lameaux/nft/apps/httpserver/golang/stdlib
NETTY_IMAGE := ghcr.io/lameaux/nft/apps/httpserver/java/netty
QUARKUS_IMAGE := ghcr.io/lameaux/nft/apps/httpserver/java/quarkus

.PHONY: all
all: docker-build-apps

.PHONY: docker-build-apps
docker-build-apps:
	docker build -t $(GOLANG_IMAGE) ./golang/stdlib
	docker build -t $(NETTY_IMAGE) ./java/netty
	docker build -t $(QUARKUS_IMAGE) ./java/quarkus