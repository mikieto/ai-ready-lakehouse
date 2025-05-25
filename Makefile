
SHELL := bash
.DEFAULT_GOAL := help
.PHONY: help bootstrap code observability guard ai-handover

help: ## List
	@grep -E '^[a-zA-Z_-]+:.*?##' $(MAKEFILE_LIST) | awk 'BEGIN{FS=".*?## "};{printf "  \033[36m%-18s\033[0m %s\n",$$1,$$2}'

bootstrap: ## Create tfstate bucket
	cd code/bootstrap && terraform init && terraform apply -auto-approve

code: bootstrap ## Provision Lakehouse (Bronze→Gold)
	cd code/main && terraform init && terraform apply -auto-approve

observability: ## Run dbt + GE tests
	cd observability/dbt && dbt deps && dbt test --profiles-dir .

guard: ## Run Rego & Infracost
	opa eval -i guard/testdata.json -d guard 'data' ; infracost breakdown --path code/main

ai-handover: ## Launch FastAPI
	uvicorn ai_handover.rag_demo.main:app --reload
