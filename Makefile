DOCKER_COMPOSE := docker compose
DEBUG := false
SKIP_BANNER := true
BROD_ADDR := brod:8080
BRO_FLAGS = --skipBanner=$(SKIP_BANNER) --debug=$(DEBUG) --brodAddr=$(BROD_ADDR)
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
test-apps: BACKENDS = golang-stdlib java-netty java-quarkus rust-axum
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
run-test-apps: run-test-apps-10k
run-test-apps: run-test-apps-benchmark

.PHONY: run-test-apps-benchmark
run-test-apps-benchmark:
	$(BRO_RUN) ./scenarios/apps/httpserver/benchmark/rps-1k-threads-100.yaml
	$(BRO_RUN) ./scenarios/apps/httpserver/benchmark/rps-5k-threads-500.yaml
	$(BRO_RUN) ./scenarios/apps/httpserver/benchmark/rps-10k-threads-1000.yaml

.PHONY: run-test-apps-10k
run-test-apps-10k:
	$(BRO_RUN) ./scenarios/apps/httpserver/golang-stdlib.yaml
	$(BRO_RUN) ./scenarios/apps/httpserver/java-netty.yaml
	$(BRO_RUN) ./scenarios/apps/httpserver/java-quarkus.yaml
	$(BRO_RUN) ./scenarios/apps/httpserver/rust-axum.yaml

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

.PHONY: minikube-start
minikube-start:
	minikube start --cpus=4 --memory=6g --bootstrapper=kubeadm \
		--extra-config=kubelet.authentication-token-webhook=true \
		--extra-config=kubelet.authorization-mode=Webhook \
		--extra-config=scheduler.bind-address=0.0.0.0 \
		--extra-config=controller-manager.bind-address=0.0.0.0
	minikube addons enable metrics-server

.PHONY: minikube-tunnel
minikube-tunnel:
	minikube tunnel

.PHONY: monitoring-setup
monitoring-setup:
	# kube-prometheus-stack
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace \
		--values monitoring/kube-prometheus-stack.yaml

.PHONY: grafana-port-forward
grafana-port-forward:
	kubectl port-forward service/kube-prometheus-stack-grafana 3000:80 -n monitoring

.PHONY: prometheus-port-forward
prometheus-port-forward:
	kubectl port-forward svc/prometheus-operated 9091:9090 -n monitoring

.PHONY: docker-build-apps
docker-build-apps:
	$(MAKE) -C apps

.PHONY: deploy-apps
deploy-apps:
	helm upgrade --install apps ./helm-charts/apps --namespace apps --create-namespace \

.PHONY: deploy-mox
deploy-mox:
	helm upgrade --install mox ./helm-charts/mox --namespace mox --create-namespace \
		--set flags.debug=false \
		--set flags.accessLog=false \

.PHONY: deploy-brod
deploy-brod:
	helm upgrade --install brod ./helm-charts/brod --namespace brod --create-namespace \
		--set flags.debug=false \

.PHONY: deploy-bro-test-mox
deploy-bro-test-mox:
	helm upgrade --install bro ./helm-charts/bro --namespace mox \
		--set scenario="scenarios/mox/static-json.yaml" \
		--set flags.debug=false \

.PHONY: deploy-bro-test-golang-stdlib
deploy-bro-test-golang-stdlib:
	helm upgrade --install bro ./helm-charts/bro --namespace apps \
		--set scenario="scenarios/apps/httpserver/golang-stdlib.yaml" \
		--set flags.debug=false \
