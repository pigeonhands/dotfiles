#!/usr/bin/env bash

DOTFILE_HOME="$HOME"
DOTFILES_DRY_RUN="0"
DOTFILES_FILTER=""
DOTFILES_VERBOSE="0"

DOTFILES_CLEAN_FOREIGN="0"

scripts=$(dirname "$0")

command="$1"
shift

while [[ $# -gt 0 ]]; do
	case "$1" in
	"--apply")
		APPLY="1"
		;;
	"-v" | "--verbose")
		DOTFILES_VERBOSE="1"
		;;
	"--foreign") # in the option loop
		DOTFILES_CLEAN_FOREIGN="1"
		;;
	--*)
		echo "unknown option: $1" >&2
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

_run_action() {
	DOTFILES_ACTION="$1"
	. "$scripts/include/targets.sh"
}

backup() {
	[[ "$APPLY" == "1" ]] && DOTFILES_DRY_RUN="0" || DOTFILES_DRY_RUN="1"
	_run_action "backup"
}

clean() {
	[[ "$APPLY" == "1" ]] && DOTFILES_DRY_RUN="0" || DOTFILES_DRY_RUN="1"
	DOTFILES_ROOT="$(pwd -P)"
	_run_action "clean"
}

new_machine() {
	local hostname="$(hostname -s)"
	local machine_dir="machines/$hostname"
	if [[ -d "$machine_dir" ]]; then
		echo -e "${_colors[error]}already exists:${_colors[reset]} ${_colors[target]}$machine_dir${_colors[reset]}" >&2
		exit 1
	fi
	mkdir -p "$machine_dir"
	echo -e "${_colors[success]}Created${_colors[reset]} ${_colors[target]}$machine_dir${_colors[reset]}"
}

usage() {
	echo "usage: manage.sh <command> [options] [filter]"
	echo ""
	echo "commands:"
	echo "  status       show symlink status for all managed files"
	echo "  check        show only problems (missing, wrong target, not a symlink)"
	echo "  list         list all managed source -> destination mappings"
	echo "  diff         show diff for destinations that differ from source"
	echo "  backup       backup existing destinations (dry run by default)"
	echo "  new-machine  scaffold machines/<hostname>/ directory"
	echo ""
	echo "options:"
	echo "  --apply        (backup) actually do it instead of a dry run"
	echo "  -v, --verbose  also show \"nothing to do\" messages (no change, filtered out)"
}

case "$command" in
"status" | "check" | "list" | "diff") _run_action "$command" ;;
"backup") backup "$@" ;;
"new-machine") new_machine ;;
"clean") clean "$@" ;; # in the command switch
"--help")
	usage
	exit 0
	;;
*)
	echo "unknown command: $command" >&2
	usage >&2
	exit 1
	;;
esac
