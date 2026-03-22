#!/usr/bin/env bash

DOTFILE_HOME="$HOME"

scripts=$(dirname "$0")

DOTFILES_FILTER=""
DOTFILES_DRY_RUN="1"
DOTFILES_FORCE="0"

usage() {
	echo "usage: setup.sh [options] [filter]"
	echo ""
	echo "options:"
	echo "  --apply   apply changes (default is dry run)"
	echo "  --dry     dry run (default)"
	echo "  --force   overwrite existing files and symlinks"
	echo "  --help    show this message"
	echo ""
	echo "filter:"
	echo "  only apply targets matching the given pattern"
	echo "  e.g. setup.sh terminals"
}

while [[ $# -gt 0 ]]; do
	echo "ARG: \"$1\""
	case "$1" in
	"--apply")
		DOTFILES_DRY_RUN="0"
		;;
	"--dry")
		DOTFILES_DRY_RUN="1"
		;;
	"--force")
		DOTFILES_FORCE="1"
		;;
	"--help")
		usage
		exit 0
		;;
	--*)
		echo "unknown option: $1" >&2
		usage >&2
		exit 1
		;;
	*)
		DOTFILES_FILTER="$1"
		;;
	esac
	shift
done

source "$scripts/include/dotfiles.sh"

cd "$scripts/.."

log "Working from ${_c_path}$(pwd)${_c_reset}"

. "$scripts/sync.sh"
