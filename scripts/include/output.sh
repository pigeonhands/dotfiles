log() {
	prefix=""
	log_count=$((log_count + 1))

	for ((i = 0; i < log_tab_index; i++)); do
		prefix+="\t"
	done

	local dry_prefix=""
	[[ $DOTFILES_DRY_RUN == "1" ]] && dry_prefix="${_colors[warn]}[DRY_RUN]${_colors[reset]}:"

	if [[ "$2" == "err" ]]; then
		echo -e "${dry_prefix}$prefix $1" >&2
	else
		echo -e "${dry_prefix}$prefix $1"
	fi

}

# Like log, but only prints when -v/--verbose is set. Use for "nothing to do" messages.
log_verbose() {
	if [[ "$DOTFILES_VERBOSE" == "1" ]]; then
		log "$@"
	fi
}
