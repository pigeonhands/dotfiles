
default: dotfiles

.PHONY: dotfiles
dotfiles:
	@ stow */ --target "$$HOME" -vv

.PHONY: ansible-setup
ansible-setup:
	ansible-playbook -vv -c localhost --ask-become-pass ./setup/setup.yml
