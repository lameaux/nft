DEBUG := false
BROD_ADDR := brod:8080
BRO_FLAGS = --skipBanner --debug=$(DEBUG) --brodAddr=$(BROD_ADDR)
BRO_RUN = docker-compose run bro $(BRO_FLAGS)
BACKENDS = brod mox nginx prometheus grafana
SHOW_RESULTS := false

.PHONY: all
all: test

.PHONY: test
test: start-backends run-tests-all wait-for-results stop-backends

.PHONY: start-backends
start-backends:
	docker-compose up $(BACKENDS) -d --wait

.PHONY: stop-backends
stop-backends:
	docker-compose down

.PHONY: run-tests-all
run-tests-all: run-test-mox run-test-nginx

.PHONY: wait-for-results
wait-for-results:
ifeq ($(SHOW_RESULTS), true)
	@echo "Test results in Grafana: http://0.0.0.0:3000"
	@echo "Press any key to continue..."
	@read
endif

.PHONY: run-test-mox
run-test-mox:
	$(BRO_RUN) ./scenarios/00-mox-static-json.yaml
	$(BRO_RUN) ./scenarios/01-mox-plain.yaml
	$(BRO_RUN) ./scenarios/02-mox-template.yaml

.PHONY: run-test-nginx
run-test-nginx:
	$(BRO_RUN) ./scenarios/03-nginx-vs-mox.yaml
	$(BRO_RUN) ./scenarios/04-nginx-calls-mox.yaml



.PHONY: run-working
run-working:
	$(BRO_RUN) ./scenarios/working/nginx-10k.yaml

