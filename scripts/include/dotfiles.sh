if [[ -z "$DOTFILE_HOME" ]]; then
	echo "DOTFILE_HOME must be set" >&2
	exit 1
fi
echo "DOTFILE_HOME: $DOTFILE_HOME"

script_dir="$(dirname "$0")"
echo "script dir: $script_dir"
cd "$script_dir"
cd ..

grep=""
dry_run="0"
force="0"

SPECIAL_DOTFILES="fold"

while [[ $# -gt 0 ]]; do
	echo "ARG: \"$1\""
	case "$1" in
	"--dry")
		dry_run="1"
		;;
	"--force")
		force="1"
		;;
	*)
		grep="$1"
		;;
	esac
	shift
done

log_tab_index="0"

log() {
	prefix=""
	for ((i = 0; i < log_tab_index; i++)); do
		prefix+="\t"
	done

	if [[ "$2" == "err" ]]; then
		if [[ $dry_run == "1" ]]; then
			echo -e "[DRY_RUN]:$prefix$1" >&2
		else
			echo -e "$prefix$1" >&2
		fi
	else
		if [[ $dry_run == "1" ]]; then
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

	if [[ $dry_run == "0" ]]; then

		rm $flags "$path"
	fi

}

get_targets() {
	local root_dir="$1"
	local targets="$(command find $root_dir -mindepth 1 -maxdepth 1 -type d)"

	for t in $targets; do
		if basename "$t" | command grep -vq "$grep"; then
			log "grep filtered out $t" "err"
		else
			echo "$t"
		fi
	done
}

apply_symlink() {
	local symlink_target="$1"

	if basename "$symlink_target" | command grep -q "^\.\($SPECIAL_DOTFILES\)\$"; then
		log "(not symlinking $(basename $symlink_target))"
		return
	fi

	local dest="$(echo $2 | sed 's/dot-/\./')"
	local sym_out=" $dest -> $symlink_target"

	local full_src="$(realpath $symlink_target)"

	if [[ -L "$dest" ]]; then
		existing_symlink="$(readlink $dest)"
		if [[ "$existing_symlink" == "$full_src" ]]; then
			log "no change for $sym_out"
			return
		elif [[ "$force" == "1" ]]; then
			remove_item "$dest" "Deleting existing symlink at $dest"
		else
			log "(skip - no force) There is an existing symlink at $dest"
			return
		fi
	fi

	if [[ -f "$dest" ]]; then
		if [[ "$force" == "1" ]]; then
			remove_item "$dest" "Deleting existing file at $dest"
		else
			log "(skip - no force) There is an existing file at $dest"
			return
		fi
	fi

	if [[ -d "$dest" ]]; then
		if [[ "$force" == "1" ]]; then
			remove_item "$dest" "Deleting existing directory at $dest" "-r"
		else
			log "(skip - no force) There is an existing directory at $dest"
			return
		fi
	fi

	log "Symlinking $sym_out"

	if [[ $dry_run == "0" ]]; then
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
		if [[ "$force" == "1" ]]; then
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

sync_dotfiles() {
	local base_dir="$1"
	local targets="$(get_targets $base_dir)"

	# [[ -n "$targets" ]] && echo "$targets" | xargs -n1 echo "Will apply:"

	if [[ -n "$targets" ]]; then
		for t in $targets; do
			echo ""
			log "Applying $t"
			log_tab_index="1"
			symlink_dir "$t"
			log_tab_index="0"
		done
	fi
}
