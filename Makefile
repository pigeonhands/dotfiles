opts ?=

.PHONY: dotfiles
dotfiles: 
	@./scripts/setup.sh $(opts)

.PHONY: dotfiles-test
dotfiles-test: 
	@./scripts/setup.sh --dry $(opts)

.PHONY: ansible-setup
ansible-setup:
	ansible-playbook -vv -c localhost --ask-become-pass ./setup/setup.yml
