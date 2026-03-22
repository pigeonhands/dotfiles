if [[ -z "$DOTFILE_HOME" ]]; then
	echo "DOTFILE_HOME must be set" >&2
	exit 1
fi

DOTFILES_DRY_RUN="${DOTFILES_DRY_RUN:-1}"
DOTFILES_FORCE="${DOTFILES_FORCE:-0}"
DOTFILES_FILTER="${DOTFILES_FILTER:-}"

SPECIAL_DOTFILES="fold|root"
log_tab_index="0"

_realpath() {
	local path="$1"
	if command -v realpath > /dev/null 2>&1; then
		realpath "$path"
	elif [[ -d "$path" ]]; then
		(cd "$path" && pwd)
	else
		echo "$(cd "$(dirname "$path")" && pwd)/$(basename "$path")"
	fi
}

log() {
	prefix=""
	for ((i = 0; i < log_tab_index; i++)); do
		prefix+="\t"
	done

	if [[ "$2" == "err" ]]; then
		if [[ $DOTFILES_DRY_RUN == "1" ]]; then
			echo -e "[DRY_RUN]:$prefix $1" >&2
		else
			echo -e "$prefix$1" >&2
		fi
	else
		if [[ $DOTFILES_DRY_RUN == "1" ]]; then
			echo -e "[DRY_RUN]:$prefix $1"
		else
			echo -e "$prefix$1"
		fi
	fi

}

remove_item() {
	path="$1"
	message="${2:-removing $path}"
	flags="$3"

	log "$message"

	if [[ $DOTFILES_DRY_RUN == "0" ]]; then

		rm $flags "$path"
	fi

}

get_targets() {
	local root_dir="$1"
	local targets="$(command find $root_dir -mindepth 1 -maxdepth 1 -type d)"

	for t in $targets; do
		if [[ -f "$t/.root" ]]; then
			echo "$t"
		elif basename "$t" | command grep -E -vq "$DOTFILES_FILTER"; then
			log "grep filtered out $t" "err"
		else
			echo "$t"
		fi
	done
}

apply_symlink() {
	local symlink_target="$1"

	if basename "$symlink_target" | command grep -E -q "^\.($SPECIAL_DOTFILES)\$"; then
		log "(not symlinking $(basename $symlink_target))"
		return
	fi

	local dest="$(echo $2 | sed 's/dot-/\./')"
	local sym_out=" $dest -> $symlink_target"

	local full_src="$(_realpath $symlink_target)"

	if [[ -L "$dest" ]]; then
		existing_symlink="$(readlink $dest)"
		if [[ "$existing_symlink" == "$full_src" ]]; then
			log "no change for $sym_out"
			return
		elif [[ "$DOTFILES_FORCE" == "1" ]]; then
			remove_item "$dest" "Deleting existing symlink at $dest"
		else
			log "(skip - no force) There is an existing symlink at $dest"
			return
		fi
	fi

	if [[ -f "$dest" ]]; then
		if [[ "$DOTFILES_FORCE" == "1" ]]; then
			remove_item "$dest" "Deleting existing file at $dest"
		else
			log "(skip - no force) There is an existing file at $dest"
			return
		fi
	fi

	if [[ -d "$dest" ]]; then
		if [[ "$DOTFILES_FORCE" == "1" ]]; then
			remove_item "$dest" "Deleting existing directory at $dest" "-r"
		else
			log "(skip - no force) There is an existing directory at $dest"
			return
		fi
	fi

	log "Symlinking $sym_out"

	if [[ $DOTFILES_DRY_RUN == "0" ]]; then
		mkdir -p "$(dirname $dest)"
		ln -s "$full_src" "$dest"
	fi
}

destination_path() {
	local source_file="$1"
	local base_dir="$2"

	local relitive_path="${source_file#$base_dir/}"
	local dest="$DOTFILE_HOME/$relitive_path"

	echo "$(echo $dest | sed 's/dot-/\./')"
}

symlink_item() {
	source_file="$1"
	base_dir="$2"

	local dest="$(destination_path $source_file $base_dir)"

	apply_symlink "$source_file" "$dest"
}

remove_intermediate_symlink() {
	local target="$1"
	local base_dir="${2:-$target}"

	local dest="$(destination_path $target $base_dir)"

	if [[ -L "$dest" ]]; then
		existing_symlink="$(readlink $dest)"
		if [[ "$DOTFILES_FORCE" == "1" ]]; then
			remove_item "$dest" "Deleting intermediate symlink at $dest"
		else
			log "(skip - no force) There is an intermediate symlink at $dest"
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
		sync_targets "$target" "$base_dir"
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
			log "Applying $t"
			log_tab_index=$((log_tab_index + 1))
			symlink_dir "$t"
			log_tab_index=$((log_tab_index - 1))
		done
	fi
}

sync_dotfiles() {

	echo ""
	echo "## applying '$1'"
	sync_targets "$1" "$2"

	if [[ $DOTFILES_DRY_RUN == "1" ]]; then
		log "run with --apply to do a non dry-run"
	fi

	echo "## done '$1'"
	echo ""
}
