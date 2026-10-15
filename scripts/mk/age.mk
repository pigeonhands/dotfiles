.PHONY: encrypt
encrypt: ## re-encrypt cached secrets that changed
	@DOTFILES_CACHE=$(DOTFILES_CACHE) ./scripts/age.sh encrypt

.PHONY: add-secret
add-secret: ## encrypt a new secret: make add-secret in=<file> out=<dotfiles-path>
	@[ -n "$(in)" ] || (echo "usage: make add-secret in=<file> out=<dotfiles-path>"; exit 1)
	@[ -n "$(out)" ] || (echo "usage: make add-secret in=<file> out=<dotfiles-path>"; exit 1)
	@DOTFILES_CACHE=$(DOTFILES_CACHE) ./scripts/age.sh add-secret "$(in)" "$(out)"

.PHONY: watch
watch: ## watch the cache and re-encrypt secrets on save
	@DOTFILES_CACHE=$(DOTFILES_CACHE) ./scripts/age.sh watch
