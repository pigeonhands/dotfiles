_decrypt_to_cache() {
	local source="$1"
	local cached="$DOTFILES_CACHE_DIR/${source%.age}"

	if [[ "$DOTFILES_ACTION" == "sync" ]]; then
		log "Decrypting ${_c_path}$source${_c_reset}" "err"
		_run mkdir -p "$(dirname "$cached")"
		_run age --decrypt -i "$AGE_KEY_FILE" -o "$cached" "$source"
	fi

	echo "$cached"
}

_action_list() {
	local src="$1" dest="$2"
	log "${_c_path}$dest${_c_reset} -> ${_c_path}$src${_c_reset}"
}

_check_age_freshness() {
	local src="$1" original="$2"
	[[ "$original" != *.age ]] && return
	[[ ! -f "$src" ]] && return
	[[ "$src" -nt "$original" ]] && log "${_c_yellow}needs encrypt${_c_reset} ${_c_path}$original${_c_reset}"
}

_action_status() {
	local src="$1" dest="$2" original="$3"
	local full_src="$(_realpath "$src")"
	if [[ -L "$dest" ]]; then
		if [[ "$(readlink "$dest")" == "$full_src" ]]; then
			log "${_c_green}ok${_c_reset} ${_c_path}$dest${_c_reset}"
		else
			log "${_c_yellow}wrong target${_c_reset} ${_c_path}$dest${_c_reset} -> $(readlink "$dest")"
		fi
	elif [[ -e "$dest" ]]; then
		log "${_c_red}not a symlink${_c_reset} ${_c_path}$dest${_c_reset}"
	else
		log "${_c_red}missing${_c_reset} ${_c_path}$dest${_c_reset}"
	fi
	_check_age_freshness "$src" "$original"
}

_action_check() {
	local src="$1" dest="$2" original="$3"
	local full_src="$(_realpath "$src")"
	if [[ -L "$dest" ]]; then
		[[ "$(readlink "$dest")" != "$full_src" ]] && \
			log "${_c_yellow}wrong target${_c_reset} ${_c_path}$dest${_c_reset} -> $(readlink "$dest")"
	elif [[ -e "$dest" ]]; then
		log "${_c_red}not a symlink${_c_reset} ${_c_path}$dest${_c_reset}"
	else
		log "${_c_red}missing${_c_reset} ${_c_path}$dest${_c_reset}"
	fi
	_check_age_freshness "$src" "$original"
}

_action_backup() {
	local dest="$1" full_src="$2"
	[[ ! -e "$dest" ]] && return
	[[ -L "$dest" ]] && [[ "$(readlink "$dest")" == "$full_src" ]] && return
	local backup_path="$DOTFILES_BACKUP_DIR/$dest"
	log "Backing up ${_c_path}$dest${_c_reset} -> ${_c_path}$backup_path${_c_reset}"
	_run mkdir -p "$(dirname "$backup_path")"
	_run cp -rP "$dest" "$backup_path"
}

_action_diff() {
	local src="$1" dest="$2"
	local full_src="$(_realpath "$src")"
	[[ ! -e "$dest" ]] && log "${_c_red}missing${_c_reset} ${_c_path}$dest${_c_reset}" && return
	[[ -L "$dest" ]] && [[ "$(readlink "$dest")" == "$full_src" ]] && return
	[[ -f "$dest" ]] && echo -e "${_c_cyan}diff${_c_reset} ${_c_path}$dest${_c_reset}" && diff "$src" "$dest" || true
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
		[[ "$DOTFILES_ACTION" == "sync" ]] && log "${_c_magenta}(not symlinking $(basename "$src"))${_c_reset}"
		return
	fi

	case "$DOTFILES_ACTION" in
	"list")   _action_list "$src" "$dest" ;;
	"status") _action_status "$src" "$dest" "$source_file" ;;
	"check")  _action_check "$src" "$dest" "$source_file" ;;
	"backup") _action_backup "$dest" "$(_realpath "$src")" ;;
	"diff")   _action_diff "$src" "$dest" ;;
	"sync")   apply_symlink "$src" "$dest" ;;
	*)
		echo "unknown action: $DOTFILES_ACTION" >&2
		exit 1
		;;
	esac
}
