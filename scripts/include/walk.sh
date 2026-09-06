_sync_targets_filtered() {
	local match_against="$1"
	local target="$2"
	local base="$3"

	local saved_filter="$DOTFILES_FILTER"
	_filter_matches "$match_against" && DOTFILES_FILTER=""
	sync_targets "$target" "$base"
	DOTFILES_FILTER="$saved_filter"
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
