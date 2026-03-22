opts ?=
grep ?=

.PHONY: dry
dry:
	@./scripts/setup.sh $(opts) '$(grep)'

.PHONY: apply
apply:
	@./scripts/setup.sh --apply $(opts) '$(grep)'
