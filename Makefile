DEBUG := false
METRICS_PORT := 9090
BRO_FLAGS = --debug=$(DEBUG) --metricsPort=$(METRICS_PORT)
BRO_RUN = docker-compose run bro $(BRO_FLAGS)

.PHONY: all
all: test

.PHONY: test
test: mox-start run-tests mox-stop

.PHONY: mox-start
mox-start:
	docker-compose up mox -d --wait

.PHONY: mox-stop
mox-stop:
	docker-compose down

.PHONY: run-tests
run-tests: run-test-constant


.PHONY: run-test-constant
run-test-constant:
	$(BRO_RUN) ./scenarios/01-simple-constant-rate.yaml

