.PHONY: help
help: ## show this help
	@echo "usage: make <target> [grep=<filter>] [opts=<options>]"
	@echo ""
	@echo "targets:"
	@awk 'BEGIN { FS = ":.*## " } /^[a-zA-Z_-]+:.*## / { printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""
	@echo "variables:"
	@echo "  grep=<regex>   only act on targets matching the pattern (e.g. make dry grep=shell)"
	@echo "  opts=<flags>   extra flags for the script (e.g. opts=-v, opts=--force)"
	@echo "  in= / out=     source file and dotfiles path for add-secret"
