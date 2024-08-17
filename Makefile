DEBUG := true
METRICS_PORT = 9090

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
	docker-compose run bro --debug=$(DEBUG) --metricsPort=$(METRICS_PORT) ./scenarios/01-simple-constant-rate.yaml

