.PHONY: dry
dry: ## show what would be symlinked (dry run)
	@./scripts/setup.sh $(opts) '$(grep)'

.PHONY: apply
apply: ## create the symlinks for real
	@./scripts/setup.sh --apply $(opts) '$(grep)'
