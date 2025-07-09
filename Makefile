
default: dotfiles

.PHONY: dotfiles
dotfiles:
	@ stow */ --target "$$HOME" -vv
