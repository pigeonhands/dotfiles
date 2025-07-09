
default: dotfiles

.PHONY: dotfiles
dotfiles:
	@ stow */ --target "$$HOME" -vv

.PHONY: ansible-setup
ansible-setup:
	ansible-playbook -c localhost ./setup/setup.yml
