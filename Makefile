opts ?=
grep ?=
DOTFILES_CACHE ?= .dotfiles-cache

include scripts/mk/*.mk

.DEFAULT_GOAL := dry

.PHONY: install-packages
install-packages:
	./scripts/install-packages.py
