apply_symlink() {
	local symlink_target="$1"

	local dest="$(echo $2 | sed 's/dot-/\./')"
	local sym_out=" ${_colors[target]}$dest${_colors[reset]} -> ${_colors[target]}$symlink_target${_colors[reset]}"

	local full_src="$(_realpath $symlink_target)"

	if [[ -L "$dest" ]]; then
		existing_symlink="$(readlink $dest)"
		if [[ "$existing_symlink" == "$full_src" ]]; then
			log_verbose "${_colors[success]}no change for${_colors[reset]}$sym_out"
			return
		elif _is_force; then
			remove_item "$dest" "${_colors[error]}Deleting${_colors[reset]} existing symlink at ${_colors[target]}$dest${_colors[reset]}"
		else
			log "${_colors[skip]}(skip - no force)${_colors[reset]} There is an existing symlink at ${_colors[target]}$dest${_colors[reset]}"
			return
		fi
	fi

	if [[ -f "$dest" ]]; then
		if _is_force; then
			remove_item "$dest" "${_colors[error]}Deleting${_colors[reset]} existing file at ${_colors[target]}$dest${_colors[reset]}"
		else
			log "${_colors[skip]}(skip - no force)${_colors[reset]} There is an existing file at ${_colors[target]}$dest${_colors[reset]}"
			return
		fi
	fi

	if [[ -d "$dest" ]]; then
		if _is_force; then
			remove_item "$dest" "${_colors[error]}Deleting${_colors[reset]} existing directory at ${_colors[target]}$dest${_colors[reset]}" "-r"
		else
			log "${_colors[skip]}(skip - no force)${_colors[reset]} There is an existing directory at ${_colors[target]}$dest${_colors[reset]}"
			return
		fi
	fi

	log "${_colors[action]}Symlinking${_colors[reset]}$sym_out"

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

remove_intermediate_symlink() {
	local target="$1"
	local base_dir="${2:-$target}"

	local dest="$(destination_path $target $base_dir)"

	if [[ -L "$dest" ]]; then
		existing_symlink="$(readlink $dest)"
		if _is_force; then
			remove_item "$dest" "${_colors[error]}Deleting${_colors[reset]} intermediate symlink at ${_colors[target]}$dest${_colors[reset]}"
		else
			log "${_colors[skip]}(skip - no force)${_colors[reset]} There is an intermediate symlink at ${_colors[target]}$dest${_colors[reset]}"
			return 1
		fi
	fi
}
