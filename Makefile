STOW_ARGS ?=

.PHONY: dotfiles
dotfiles: common-dotfiles machine-dotfiles

.PHONY: common-dotfiles
common-dotfiles:
	@$(MAKE) stow cfg=common target=$$HOME

.PHONY: machine-dotfiles
machine-dotfiles:
	@[ -d $$(hostname) ] && $(MAKE) stow cfg=$$(hostname) target=$$HOME

.PHONY: stow
stow:
ifndef cfg
	$(error cfg is undefined)
endif
ifndef target
	$(error cfg is undefined)
endif
	@ cd $(cfg) && stow $(STOW_ARGS) --dotfiles --target "$(target)" -vv */

.PHONY: ansible-setup
ansible-setup:
	ansible-playbook -vv -c localhost --ask-become-pass ./setup/setup.yml
