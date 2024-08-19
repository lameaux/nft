DEBUG := false
METRICS_PORT := 9090
BRO_FLAGS = --skipBanner --debug=$(DEBUG) --metricsPort=$(METRICS_PORT)
BRO_RUN = docker-compose run bro $(BRO_FLAGS)

.PHONY: all
all: test

.PHONY: test
test: start-backends run-tests stop-backends

.PHONY: mox-start
start-backends:
	docker-compose up mox nginx -d --wait

.PHONY: mox-stop
stop-backends:
	docker-compose down

.PHONY: run-tests
run-tests: run-test-mox run-test-nginx

.PHONY: run-test-mox
run-test-mox:
	$(BRO_RUN) ./scenarios/01-simple-constant-rate.yaml

.PHONY: run-test-nginx
run-test-nginx:
	$(BRO_RUN) ./scenarios/02-nginx.yaml

