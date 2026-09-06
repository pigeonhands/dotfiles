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
