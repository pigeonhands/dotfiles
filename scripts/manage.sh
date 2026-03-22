#!/usr/bin/env bash

DOTFILE_HOME="$HOME"
DOTFILES_DRY_RUN="0"
DOTFILES_FILTER=""

scripts=$(dirname "$0")

command="$1"
shift

while [[ $# -gt 0 ]]; do
	case "$1" in
	"--apply")
		APPLY="1"
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
	. "$scripts/sync.sh"
}

status() {
	_run_action "status"
}

check() {
	_run_action "check"
}

list() {
	_run_action "list"
}

diff_all() {
	_run_action "diff"
}

backup() {
	[[ "$APPLY" == "1" ]] && DOTFILES_DRY_RUN="0" || DOTFILES_DRY_RUN="1"
	_run_action "backup"
}

new_machine() {
	local hostname="$(hostname -s)"
	local machine_dir="machines/$hostname"
	if [[ -d "$machine_dir" ]]; then
		echo -e "${_c_red}already exists:${_c_reset} ${_c_path}$machine_dir${_c_reset}" >&2
		exit 1
	fi
	mkdir -p "$machine_dir"
	echo -e "${_c_green}Created${_c_reset} ${_c_path}$machine_dir${_c_reset}"
}

usage() {
	echo "usage: manage.sh <command>"
	echo ""
	echo "commands:"
	echo "  status       show symlink status for all managed files"
	echo "  check        show only problems (missing, wrong target, not a symlink)"
	echo "  list         list all managed source -> destination mappings"
	echo "  diff         show diff for destinations that differ from source"
	echo "  backup       backup existing destinations (dry run by default)"
	echo "  new-machine  scaffold machines/<hostname>/ directory"
}

case "$command" in
"status")      status ;;
"check")       check ;;
"list")        list ;;
"diff")        diff_all ;;
"backup")      backup "$@" ;;
"new-machine") new_machine ;;
"--help")      usage; exit 0 ;;
*)
	echo "unknown command: $command" >&2
	usage >&2
	exit 1
	;;
esac
