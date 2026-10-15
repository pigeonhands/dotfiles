_decrypt_to_cache() {
	local source="$1"
	local cached="$DOTFILES_CACHE_DIR/${source%.age}"

	if [[ "$DOTFILES_ACTION" == "sync" ]]; then
		log "Decrypting ${_colors[target]}$source${_colors[reset]}" "err"
		_run mkdir -p "$(dirname "$cached")"
		_run age --decrypt -i "$AGE_KEY_FILE" -o "$cached" "$source"
	fi

	echo "$cached"
}

_action_list() {
	local src="$1" dest="$2"
	log "${_colors[target]}$dest${_colors[reset]} -> ${_colors[target]}$src${_colors[reset]}"
}

_check_age_freshness() {
	local src="$1" original="$2"
	[[ "$original" != *.age ]] && return
	[[ ! -f "$src" ]] && return
	[[ "$src" -nt "$original" ]] && log "${_colors[warn]}needs encrypt${_colors[reset]} ${_colors[target]}$original${_colors[reset]}"
}

_action_status() {
	local src="$1" dest="$2" original="$3"
	local full_src="$(_realpath "$src")"
	if [[ -L "$dest" ]]; then
		if [[ "$(readlink "$dest")" == "$full_src" ]]; then
			log "${_colors[success]}ok${_colors[reset]} ${_colors[target]}$dest${_colors[reset]}"
		else
			log "${_colors[warn]}wrong target${_colors[reset]} ${_colors[target]}$dest${_colors[reset]} -> $(readlink "$dest")"
		fi
	elif [[ -e "$dest" ]]; then
		log "${_colors[error]}not a symlink${_colors[reset]} ${_colors[target]}$dest${_colors[reset]}"
	else
		log "${_colors[error]}missing${_colors[reset]} ${_colors[target]}$dest${_colors[reset]}"
	fi
	_check_age_freshness "$src" "$original"
}

_action_check() {
	local src="$1" dest="$2" original="$3"
	local full_src="$(_realpath "$src")"
	if [[ -L "$dest" ]]; then
		[[ "$(readlink "$dest")" != "$full_src" ]] &&
			log "${_colors[warn]}wrong target${_colors[reset]} ${_colors[target]}$dest${_colors[reset]} -> $(readlink "$dest")"
	elif [[ -e "$dest" ]]; then
		log "${_colors[error]}not a symlink${_colors[reset]} ${_colors[target]}$dest${_colors[reset]}"
	else
		log "${_colors[error]}missing${_colors[reset]} ${_colors[target]}$dest${_colors[reset]}"
	fi
	_check_age_freshness "$src" "$original"
}

_action_backup() {
	local dest="$1" full_src="$2"
	[[ ! -e "$dest" ]] && return
	[[ -L "$dest" ]] && [[ "$(readlink "$dest")" == "$full_src" ]] && return
	local backup_path="$DOTFILES_BACKUP_DIR/$dest"
	log "Backing up ${_colors[target]}$dest${_colors[reset]} -> ${_colors[target]}$backup_path${_colors[reset]}"
	_run mkdir -p "$(dirname "$backup_path")"
	_run cp -rP "$dest" "$backup_path"
}

_action_diff() {
	local src="$1" dest="$2"
	local full_src="$(_realpath "$src")"
	[[ ! -e "$dest" ]] && log "${_colors[error]}missing${_colors[reset]} ${_colors[target]}$dest${_colors[reset]}" && return
	[[ -L "$dest" ]] && [[ "$(readlink "$dest")" == "$full_src" ]] && return
	[[ -f "$dest" ]] && echo -e "${_colors[info]}diff${_colors[reset]} ${_colors[target]}$dest${_colors[reset]}" && diff "$src" "$dest" || true
}

symlink_item() {
	source_file="$1"
	base_dir="$2"

	local src dest
	if [[ "$source_file" == *.age ]]; then
		src="$(_decrypt_to_cache "$source_file")"
		dest="$(destination_path "${source_file%.age}" "$base_dir")"
	else
		src="$source_file"
		dest="$(destination_path "$source_file" "$base_dir")"
	fi

	if basename "$src" | command grep -E -q "^\.($SPECIAL_DOTFILES)\$"; then
		[[ "$DOTFILES_ACTION" == "sync" ]] && log "${_colors[skip]}(not symlinking $(basename "$src"))${_colors[reset]}"
		return
	fi

	case "$DOTFILES_ACTION" in
	"list") _action_list "$src" "$dest" ;;
	"status") _action_status "$src" "$dest" "$source_file" ;;
	"check") _action_check "$src" "$dest" "$source_file" ;;
	"backup") _action_backup "$dest" "$(_realpath "$src")" ;;
	"diff") _action_diff "$src" "$dest" ;;
	"sync") apply_symlink "$src" "$dest" ;;
	"clean") ;; # handled per directory in symlink_dir
	*)
		echo "unknown action: $DOTFILES_ACTION" >&2
		exit 1
		;;
	esac
}
