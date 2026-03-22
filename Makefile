opts ?=
grep ?=
DOTFILES_CACHE ?= .dotfiles-cache


.PHONY: dry
dry:
	@./scripts/setup.sh $(opts) '$(grep)'

.PHONY: apply
apply:
	@./scripts/setup.sh --apply $(opts) '$(grep)'

.PHONY: encrypt
encrypt:
	@DOTFILES_CACHE=$(DOTFILES_CACHE) ./scripts/age.sh encrypt

.PHONY: add-secret
add-secret:
	@[ -n "$(in)" ] || (echo "usage: make add-secret in=<file> out=<dotfiles-path>"; exit 1)
	@[ -n "$(out)" ] || (echo "usage: make add-secret in=<file> out=<dotfiles-path>"; exit 1)
	@DOTFILES_CACHE=$(DOTFILES_CACHE) ./scripts/age.sh add-secret "$(in)" "$(out)"

.PHONY: watch
watch:
	@DOTFILES_CACHE=$(DOTFILES_CACHE) ./scripts/age.sh watch
