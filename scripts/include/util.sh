_run() {
	[[ $DOTFILES_DRY_RUN == "0" ]] && "$@"
}

_is_force() {
	[[ "$DOTFILES_FORCE" == "1" ]]
}

_filter_matches() {
	[[ -z "$DOTFILES_FILTER" ]] || echo "$1" | command grep -E -q "$DOTFILES_FILTER"
}

_realpath() {
	local path="$1"
	[[ "$path" = /* ]] && echo "$path" && return
	if command -v realpath >/dev/null 2>&1; then
		realpath "$path" 2>/dev/null || echo "$PWD/$path"
	elif [[ -d "$path" ]]; then
		(cd "$path" && pwd)
	else
		echo "$(cd "$(dirname "$path")" 2>/dev/null && pwd || echo "$PWD/$(dirname "$path")")/$(basename "$path")"
	fi
}

remove_item() {
	path="$1"
	message="${2:-removing $path}"
	flags="$3"

	log "$message"
	_run rm $flags "$path"

}
