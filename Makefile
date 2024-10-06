DOCKER_COMPOSE := docker compose
DEBUG := false
BROD_ADDR := brod:8080
BRO_FLAGS = --skipBanner --debug=$(DEBUG) --brodAddr=$(BROD_ADDR)
BRO_RUN = $(DOCKER_COMPOSE) run bro $(BRO_FLAGS)
BACKENDS = brod prometheus grafana
SHOW_RESULTS := false

.PHONY: all
all: test

.PHONY: test
test: test-mox test-nginx

.PHONY: test-mox
test-mox: BACKENDS = brod mox prometheus grafana
test-mox: start-backends run-test-mox stop-backends

.PHONY: test-nginx
test-nginx: BACKENDS = brod mox nginx prometheus grafana
test-nginx: start-backends run-test-mox stop-backends

.PHONY: test-apps
test-apps: BACKENDS = golang-stdlib java-netty java-quarkus
test-apps: BROD_ADDR =
test-apps: start-backends run-test-apps stop-backends

.PHONY: run-test-mox
run-test-mox:
	$(BRO_RUN) ./scenarios/mox/static-json.yaml
	$(BRO_RUN) ./scenarios/mox/plain.yaml
	$(BRO_RUN) ./scenarios/mox/template.yaml

.PHONY: run-test-nginx
run-test-nginx:
	$(BRO_RUN) ./scenarios/nginx/vs-mox.yaml
	$(BRO_RUN) ./scenarios/nginx/calls-mox.yaml

.PHONY: run-test-mox-sleep
run-test-mox-sleep:
	$(BRO_RUN) ./scenarios/mox/sleep.yaml

.PHONY: run-test-nginx-10k
run-test-nginx-10k:
	$(BRO_RUN) ./scenarios/nginx/10k.yaml

.PHONY: run-test-apps
run-test-apps:
	$(BRO_RUN) ./scenarios/apps/httpserver/golang-stdlib.yaml
	$(BRO_RUN) ./scenarios/apps/httpserver/java-netty.yaml
	$(BRO_RUN) ./scenarios/apps/httpserver/java-quarkus.yaml

.PHONY: start-backends
start-backends:
	$(DOCKER_COMPOSE) up $(BACKENDS) -d --wait

.PHONY: stop-backends
stop-backends: wait-for-results
	$(DOCKER_COMPOSE) down

.PHONY: wait-for-results
wait-for-results:
ifeq ($(SHOW_RESULTS), true)
	@echo "Test results in Grafana: http://0.0.0.0:3000"
	@echo "Press any key to continue..."
	@read
endif

.PHONY: docker-build-apps
docker-build-apps:
	$(MAKE) -C apps
