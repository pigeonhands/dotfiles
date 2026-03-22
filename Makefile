opts ?=
grep ?=

.PHONY: dotfiles
dotfiles: 
	@./scripts/setup.sh $(opts) '$(grep)'

.PHONY: dotfiles-test
apply: 
	@./scripts/setup.sh --apply $(opts) '$(grep)'

