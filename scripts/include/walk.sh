_action_verb() {
	case "$DOTFILES_ACTION" in
	"list") echo "Listing" ;;
	"status") echo "Checking status of" ;;
	"check") echo "Checking" ;;
	"diff") echo "Diffing" ;;
	"backup") echo "Backing up" ;;
	"clean") echo "Cleaning" ;;
	*) echo "Applying" ;;
	esac
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

get_targets() {
	local root_dir="$1"
	local targets="$(command find $root_dir -mindepth 1 -maxdepth 1 -type d)"

	for t in $targets; do
		if [[ -f "$t/.root" ]]; then
			echo "$t"
		elif ! _filter_matches "$(basename "$t")"; then
			log_verbose "${_colors[error]}grep filtered out${_colors[reset]} ${_colors[target]}$t${_colors[reset]}" "err"
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

sync_targets() {
	local base_dir="$1"
	local targets="$(get_targets $base_dir)"

	if [[ -n "$targets" ]]; then
		local spacer=0
		for t in $targets; do
			[[ $spacer == 1 ]] && echo ""
			local logged_before=$log_count
			log "${_colors[info]}${_colors[bold]}$(_action_verb)${_colors[reset]} ${_colors[target]}$t${_colors[reset]}"
			log_tab_index=$((log_tab_index + 1))
			symlink_dir "$t"
			log_tab_index=$((log_tab_index - 1))
			# more than the header line itself was logged
			if ((log_count > logged_before + 1)); then spacer=1; else spacer=0; fi
		done
	fi
}

symlink_dir() {
	local target="$1"
	local base_dir="${2:-$target}"

	local dest="$(destination_path $target $base_dir)"

	if [[ -f "$base_dir/.root" ]]; then
		_sync_targets_filtered "$(basename "$target")" "$target" "$base_dir"
		return
	fi

	if [[ "$DOTFILES_ACTION" == "clean" ]]; then
		clean_dir "$target" "$base_dir"
	fi

	symlink_content "$target" "$base_dir" "f"

	for target_subdir in $(command find $target -mindepth 1 -maxdepth 1 -type d); do
		if remove_intermediate_symlink "$target_subdir" "$base_dir"; then
			if [[ -f "$target_subdir/.fold" ]]; then
				if [[ "$DOTFILES_ACTION" == "clean" ]]; then
					clean_dir "$target_subdir" "$base_dir"
				fi
				symlink_content "$target_subdir" "$base_dir"
			else
				symlink_dir "$target_subdir" "$base_dir"
			fi
		fi
	done
}

sync_dotfiles() {
	echo ""
	clean_pending=0
	echo -e "${_colors[heading]}${_colors[bold]}## $(_action_verb | tr '[:upper:]' '[:lower:]') '$1'${_colors[reset]}"
	_sync_targets_filtered "$1" "$1" "$2"

	if [[ $DOTFILES_DRY_RUN == "1" ]] && { [[ "$DOTFILES_ACTION" == "sync" ]] || { [[ "$DOTFILES_ACTION" == "clean" ]] && ((clean_pending > 0)); }; }; then
		log "${_colors[warn]}run with --apply to do a non dry-run${_colors[reset]}"
	fi

	echo -e "${_colors[heading]}${_colors[bold]}## done '$1'${_colors[reset]}"
	echo ""
}
