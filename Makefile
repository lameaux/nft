DEBUG := false
METRICS_PORT := 9090
BRO_FLAGS = --skipBanner --debug=$(DEBUG) --metricsPort=$(METRICS_PORT)
BRO_RUN = docker-compose run bro $(BRO_FLAGS)
BACKENDS = mox nginx

.PHONY: all
all: test

.PHONY: test
test: start-backends run-tests stop-backends

.PHONY: start-backends
start-backends:
	docker-compose up $(BACKENDS) -d --wait

.PHONY: stop-backends
stop-backends:
	docker-compose down

.PHONY: run-tests
run-tests: run-test-mox run-test-nginx

.PHONY: run-test-mox
run-test-mox:
	$(BRO_RUN) ./scenarios/00-mox-static-json.yaml
	$(BRO_RUN) ./scenarios/01-mox-plain.yaml
	$(BRO_RUN) ./scenarios/02-mox-template.yaml

.PHONY: run-test-nginx
run-test-nginx:
	$(BRO_RUN) ./scenarios/03-nginx-vs-mox.yaml
	$(BRO_RUN) ./scenarios/04-nginx-mox-downstream.yaml

