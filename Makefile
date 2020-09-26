
.ONESHELL:
.SHELL := /bin/sh
.PHONY: all help deploy
.DEFAULT_GOAL := help
CURRENT_FOLDER=$(shell basename "$$(pwd)")
BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
RESET=$(shell tput sgr0)
REPO=git@github.com:iac-projects/gitops-istio



## Burn, baby, burn
help: ## Shows this makefile help
	@echo ""
	@echo "gitops-istio!"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: deploy
	@echo "Setting up local environment"

deploy:
	chmod a+x scripts/*.sh ; \
	./scripts/flux-init.sh $(REPO)

start:
	minikube start

destroy:
	minikube delete  --all --purge


PHONY: jaeger
jaeger:
	kubectl port-forward -n istio-system $$(kubectl get pod -n istio-system -l app=jaeger -o jsonpath='{.items[0].metadata.name}' --context=minikube) --context=minikube 16686:16686

PHONY: kiali
kiali:
	kubectl port-forward -n istio-system $$(kubectl get pod -n istio-system -l app=kiali -o jsonpath='{.items[0].metadata.name}' --context=minikube) --context=minikube 20001:20001

PHONY: grafana
grafana:
	kubectl port-forward -n istio-system $$(kubectl get pod -n istio-system -l app=grafana -o jsonpath='{.items[0].metadata.name}' --context=minikube) --context=minikube 3000:3000
