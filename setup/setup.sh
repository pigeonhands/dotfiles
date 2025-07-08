#!/bin/env bash

APP_DOTFILES="$HOME/.app-dotfiles"

if [ ! -d "$APP_DOTFILES" ]; then
	git clone https://github.com/pigeonhands/dotfiles.git "$APP_DOTFILES"
fi

cd $APP_DOTFILES

if [ ! -f "$HOME/.local/bin/uvx" ]; then
	curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if [ ! -f "$HOME/.local/bin/ansible-playbook" ]; then
	~/.local/bin/uvx pipx install --pip-args "github3.py" --include-deps ansible
fi

~/.local/bin/ansible-playbook -c localhost --ask-become-pass $APP_DOTFILES/setup/setup.yml
