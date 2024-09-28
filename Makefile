DOCKER_COMPOSE := docker compose
DEBUG := false
BROD_ADDR := brod:8080
BRO_FLAGS = --skipBanner --debug=$(DEBUG) --brodAddr=$(BROD_ADDR)
BRO_RUN = $(DOCKER_COMPOSE) run bro $(BRO_FLAGS)
BACKENDS = brod mox nginx prometheus grafana
SHOW_RESULTS := false

.PHONY: all
all: test

.PHONY: test
test: start-backends run-test-all wait-for-results stop-backends

.PHONY: start-backends
start-backends:
	$(DOCKER_COMPOSE) up $(BACKENDS) -d --wait

.PHONY: stop-backends
stop-backends:
	$(DOCKER_COMPOSE) down

.PHONY: run-test-all
run-test-all: run-test-mox run-test-nginx

.PHONY: wait-for-results
wait-for-results:
ifeq ($(SHOW_RESULTS), true)
	@echo "Test results in Grafana: http://0.0.0.0:3000"
	@echo "Press any key to continue..."
	@read
endif

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

