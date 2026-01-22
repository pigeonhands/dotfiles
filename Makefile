opts ?=
grep ?=

.PHONY: dotfiles
dotfiles: 
	@./scripts/setup.sh $(opts) '$(grep)'

.PHONY: dotfiles-test
apply: 
	@./scripts/setup.sh --apply $(opts) '$(grep)'

.PHONY: ansible-setup
ansible-setup:
	ansible-playbook -vv -c localhost --ask-become-pass ./setup/setup.yml
