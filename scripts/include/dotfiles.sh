if [[ -z "$DOTFILE_HOME" ]]; then
	echo "DOTFILE_HOME must be set" >&2
	exit 1
fi

DOTFILES_DRY_RUN="${DOTFILES_DRY_RUN:-1}"
DOTFILES_FORCE="${DOTFILES_FORCE:-0}"
DOTFILES_FILTER="${DOTFILES_FILTER:-}"
DOTFILES_CACHE_DIR="${DOTFILES_CACHE_DIR:-$PWD/.dotfiles-cache}"
DOTFILES_BACKUP_DIR="${DOTFILES_BACKUP_DIR:-$PWD/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)}"
DOTFILES_ACTION="${DOTFILES_ACTION:-sync}"

AGE_KEY_FILE="${AGE_KEY_FILE:-$HOME/.age/key.txt}"
AGE_RECIPIENTS_FILE="${AGE_RECIPIENTS_FILE:-$PWD/.age-recipients}"

SPECIAL_DOTFILES="fold|root"
log_tab_index="0"

_c_reset="\033[0m"
_c_bold="\033[1m"
_c_dim="\033[2m"
_c_yellow="\033[33m"
_c_cyan="\033[36m"
_c_green="\033[32m"
_c_red="\033[31m"
_c_blue="\033[34m"
_c_magenta="\033[35m"
_c_path="\033[96m"

_run() {
	[[ $DOTFILES_DRY_RUN == "0" ]] && "$@"
}

_is_force() {
	[[ "$DOTFILES_FORCE" == "1" ]]
}

_filter_matches() {
	[[ -z "$DOTFILES_FILTER" ]] || echo "$1" | command grep -E -q "$DOTFILES_FILTER"
}

_sync_targets_filtered() {
	local match_against="$1"
	local target="$2"
	local base="$3"

	local saved_filter="$DOTFILES_FILTER"
	_filter_matches "$match_against" && DOTFILES_FILTER=""
	sync_targets "$target" "$base"
	DOTFILES_FILTER="$saved_filter"
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

log() {
	prefix=""
	for ((i = 0; i < log_tab_index; i++)); do
		prefix+="\t"
	done

	local dry_prefix=""
	[[ $DOTFILES_DRY_RUN == "1" ]] && dry_prefix="${_c_yellow}[DRY_RUN]${_c_reset}:"

	if [[ "$2" == "err" ]]; then
		echo -e "${dry_prefix}$prefix $1" >&2
	else
		echo -e "${dry_prefix}$prefix $1"
	fi

}

remove_item() {
	path="$1"
	message="${2:-removing $path}"
	flags="$3"

	log "$message"
	_run rm $flags "$path"

}

get_targets() {
	local root_dir="$1"
	local targets="$(command find $root_dir -mindepth 1 -maxdepth 1 -type d)"

	for t in $targets; do
		if [[ -f "$t/.root" ]]; then
			echo "$t"
		elif ! _filter_matches "$(basename "$t")"; then
			log "${_c_red}grep filtered out${_c_reset} ${_c_path}$t${_c_reset}" "err"
		else
			echo "$t"
		fi
	done
}

apply_symlink() {
	local symlink_target="$1"

	local dest="$(echo $2 | sed 's/dot-/\./')"
	local sym_out=" ${_c_path}$dest${_c_reset} -> ${_c_path}$symlink_target${_c_reset}"

	local full_src="$(_realpath $symlink_target)"

	if [[ -L "$dest" ]]; then
		existing_symlink="$(readlink $dest)"
		if [[ "$existing_symlink" == "$full_src" ]]; then
			log "${_c_green}no change for${_c_reset}$sym_out"
			return
		elif _is_force; then
			remove_item "$dest" "${_c_red}Deleting${_c_reset} existing symlink at ${_c_path}$dest${_c_reset}"
		else
			log "${_c_magenta}(skip - no force)${_c_reset} There is an existing symlink at ${_c_path}$dest${_c_reset}"
			return
		fi
	fi

	if [[ -f "$dest" ]]; then
		if _is_force; then
			remove_item "$dest" "${_c_red}Deleting${_c_reset} existing file at ${_c_path}$dest${_c_reset}"
		else
			log "${_c_magenta}(skip - no force)${_c_reset} There is an existing file at ${_c_path}$dest${_c_reset}"
			return
		fi
	fi

	if [[ -d "$dest" ]]; then
		if _is_force; then
			remove_item "$dest" "${_c_red}Deleting${_c_reset} existing directory at ${_c_path}$dest${_c_reset}" "-r"
		else
			log "${_c_magenta}(skip - no force)${_c_reset} There is an existing directory at ${_c_path}$dest${_c_reset}"
			return
		fi
	fi

	log "${_c_green}Symlinking${_c_reset}$sym_out"

	_run mkdir -p "$(dirname $dest)"
	_run ln -s "$full_src" "$dest"
}

destination_path() {
	local source_file="$1"
	local base_dir="$2"

	local relitive_path="${source_file#$base_dir/}"
	local dest="$DOTFILE_HOME/$relitive_path"

	echo "$(echo $dest | sed 's/dot-/\./')"
}

_decrypt_to_cache() {
	local source="$1"
	local cached="$DOTFILES_CACHE_DIR/${source%.age}"

	if [[ "$DOTFILES_ACTION" == "sync" ]]; then
		log "Decrypting ${_c_path}$source${_c_reset}"
		_run mkdir -p "$(dirname "$cached")"
		_run age --decrypt -i "$AGE_KEY_FILE" -o "$cached" "$source"
	fi

	echo "$cached"
}

_action_list() {
	local src="$1" dest="$2"
	log "${_c_path}$dest${_c_reset} -> ${_c_path}$src${_c_reset}"
}

_action_status() {
	local src="$1" dest="$2"
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
}

_action_check() {
	local src="$1" dest="$2"
	local full_src="$(_realpath "$src")"
	if [[ -L "$dest" ]]; then
		[[ "$(readlink "$dest")" != "$full_src" ]] && \
			log "${_c_yellow}wrong target${_c_reset} ${_c_path}$dest${_c_reset} -> $(readlink "$dest")"
	elif [[ -e "$dest" ]]; then
		log "${_c_red}not a symlink${_c_reset} ${_c_path}$dest${_c_reset}"
	else
		log "${_c_red}missing${_c_reset} ${_c_path}$dest${_c_reset}"
	fi
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
	"status") _action_status "$src" "$dest" ;;
	"check")  _action_check "$src" "$dest" ;;
	"backup") _action_backup "$dest" "$(_realpath "$src")" ;;
	"diff")   _action_diff "$src" "$dest" ;;
	"sync")   apply_symlink "$src" "$dest" ;;
	*)
		echo "unknown action: $DOTFILES_ACTION" >&2
		exit 1
		;;
	esac
}

remove_intermediate_symlink() {
	local target="$1"
	local base_dir="${2:-$target}"

	local dest="$(destination_path $target $base_dir)"

	if [[ -L "$dest" ]]; then
		existing_symlink="$(readlink $dest)"
		if _is_force; then
			remove_item "$dest" "${_c_red}Deleting${_c_reset} intermediate symlink at ${_c_path}$dest${_c_reset}"
		else
			log "${_c_magenta}(skip - no force)${_c_reset} There is an intermediate symlink at ${_c_path}$dest${_c_reset}"
			return 1
		fi
	fi
}

symlink_content() {
	local target="$1"
	local base_dir="${2:-$target}"
	local type="$3"

	flags=""
	[[ -n "$type" ]] && flags+="-type $type"

	for item in $(command find $target -mindepth 1 -maxdepth 1 $flags); do
		symlink_item "$item" "$base_dir"
	done
}

symlink_dir() {
	local target="$1"
	local base_dir="${2:-$target}"

	local dest="$(destination_path $target $base_dir)"

	if [[ -f "$base_dir/.root" ]]; then
		_sync_targets_filtered "$(basename "$target")" "$target" "$base_dir"
		return
	fi

	symlink_content "$target" "$base_dir" "f"

	for target_subdir in $(command find $target -mindepth 1 -maxdepth 1 -type d); do
		if remove_intermediate_symlink "$target_subdir" "$base_dir"; then
			if [[ -f "$target_subdir/.fold" ]]; then
				symlink_content "$target_subdir" "$base_dir"
			else
				symlink_dir "$target_subdir" "$base_dir"
			fi
		fi
	done
}

sync_targets() {
	local base_dir="$1"
	local targets="$(get_targets $base_dir)"

	if [[ -n "$targets" ]]; then
		for t in $targets; do
			echo ""
			log "${_c_cyan}${_c_bold}Applying${_c_reset} ${_c_path}$t${_c_reset}"
			log_tab_index=$((log_tab_index + 1))
			symlink_dir "$t"
			log_tab_index=$((log_tab_index - 1))
		done
	fi
}

sync_dotfiles() {
	echo ""
	echo -e "${_c_blue}${_c_bold}## applying '$1'${_c_reset}"
	_sync_targets_filtered "$1" "$1" "$2"

	if [[ $DOTFILES_DRY_RUN == "1" ]] && [[ "$DOTFILES_ACTION" == "sync" ]]; then
		log "${_c_yellow}run with --apply to do a non dry-run${_c_reset}"
	fi

	echo -e "${_c_blue}${_c_bold}## done '$1'${_c_reset}"
	echo ""
}
