#!/usr/bin/env bash

DOTFILE_HOME="$HOME"

scripts=$(dirname "$0")
source "$scripts/include/dotfiles.sh"

command="${1:-sync}"

log "Working from $(pwd)"

case "$command" in
"sync")
	. "$scripts/sync.sh"
	;;
*)
	echo "Unknown command $command"
	exit 1
	;;
esac
