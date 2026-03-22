opts ?=
grep ?=
DOTFILES_CACHE ?= .dotfiles-cache


.PHONY: dry
dry:
	@./scripts/setup.sh $(opts) '$(grep)'

.PHONY: apply
apply:
	@./scripts/setup.sh --apply $(opts) '$(grep)'

.PHONY: status
status:
	@./scripts/manage.sh status '$(grep)'

.PHONY: check
check:
	@./scripts/manage.sh check '$(grep)'

.PHONY: list
list:
	@./scripts/manage.sh list '$(grep)'

.PHONY: diff
diff:
	@./scripts/manage.sh diff '$(grep)'

.PHONY: backup
backup:
	@./scripts/manage.sh backup '$(grep)' $(opts)

.PHONY: new-machine
new-machine:
	@./scripts/manage.sh new-machine

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
