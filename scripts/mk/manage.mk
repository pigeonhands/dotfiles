.PHONY: status
status: ## show symlink status for all managed files
	@./scripts/manage.sh status '$(grep)' $(opts)

.PHONY: check
check: ## show only problems (missing, wrong target, not a symlink)
	@./scripts/manage.sh check '$(grep)' $(opts)

.PHONY: list
list: ## list all managed source -> destination mappings
	@./scripts/manage.sh list '$(grep)' $(opts)

.PHONY: diff
diff: ## show diff for destinations that differ from source
	@./scripts/manage.sh diff '$(grep)' $(opts)

.PHONY: backup
backup: ## back up existing destinations (dry run unless opts=--apply)
	@./scripts/manage.sh backup '$(grep)' $(opts)

.PHONY: clean
clean: ## find stale symlinks left by deleted sources (dry run; opts=--foreign includes non-dotfiles links)
	@./scripts/manage.sh clean '$(grep)' $(opts)

.PHONY: clean-apply
clean-apply: ## delete the stale symlinks found by clean
	@./scripts/manage.sh clean --apply '$(grep)' $(opts)

.PHONY: new-machine
new-machine: ## scaffold machines/<hostname>/ directory
	@./scripts/manage.sh new-machine
