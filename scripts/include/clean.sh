# Stale symlink detection / cleanup.
#
# For every destination directory managed by a target, look at the symlinks that
# sit directly inside it and report the ones that are broken:
#   - broken and pointing into the dotfiles repo  -> "stale" (source was deleted/renamed)
#   - broken and pointing anywhere else           -> "foreign" (warn only, unless DOTFILES_CLEAN_FOREIGN=1)
# Working symlinks are never touched. Deletion respects DOTFILES_DRY_RUN.

declare -gA _clean_seen=()
clean_pending=0 # number of symlinks that were (or, in a dry run, would be) removed

# Does this source directory directly manage anything (so its destination is a "known" dir)?
_manages_items() {
	local target="$1"
	[[ -f "$target/.fold" ]] && return 0
	[[ -n "$(command find "$target" -mindepth 1 -maxdepth 1 -type f ! -name .fold ! -name .root -print -quit)" ]]
}

# Absolute, normalised path that a symlink points at (works for broken links)
_resolve_link_target() {
	local link="$1"
	local target="$(readlink "$link")"
	[[ "$target" != /* ]] && target="$(dirname "$link")/$target"
	if command -v realpath >/dev/null 2>&1; then
		realpath -m "$target" 2>/dev/null || echo "$target"
	else
		echo "$target"
	fi
}

# The directory a source directory gets linked into
_dest_dir() {
	local target="$1" base_dir="$2"
	if [[ "$target" == "$base_dir" ]]; then
		echo "$DOTFILE_HOME"
	else
		destination_path "$target" "$base_dir"
	fi
}

clean_dir() {
	local target="$1"
	local base_dir="${2:-$target}"
	local dir="$(_dest_dir "$target" "$base_dir")"

	[[ -d "$dir" ]] || return 0

	# Foreign broken symlinks are only reported in "known" dirs: ones the dotfiles put items in
	# directly, e.g. ~/.config/zsh. Never the top level of the home dir, or dirs (like ~/.config)
	# that only exist to hold other managed dirs.
	local known=0
	if [[ "$dir" != "$DOTFILE_HOME" ]] && _manages_items "$target"; then
		known=1
	fi

	# A dir can be reached from several targets. Scan it once, and again (foreign links only)
	# if a later target turns out to make it a known dir.
	local seen="${_clean_seen[$dir]}" foreign_only=0
	if [[ -n "$seen" ]]; then
		((seen >= known)) && return 0
		foreign_only=1
	fi
	_clean_seen[$dir]=$known

	local link resolved found=0
	while IFS= read -r -d '' link; do
		[[ -e "$link" ]] && continue # still points at something, leave it alone
		resolved="$(_resolve_link_target "$link")"
		local desc="${_colors[target]}$link${_colors[reset]} -> $(readlink "$link")"

		if [[ "$resolved" == "$DOTFILES_ROOT"/* ]]; then
			[[ $foreign_only == 1 ]] && continue
			found=1
			clean_pending=$((clean_pending + 1))
			remove_item "$link" "${_colors[error]}Removing stale symlink${_colors[reset]} $desc"
		else
			[[ $known == 0 ]] && continue
			found=1
			if [[ "$DOTFILES_CLEAN_FOREIGN" == "1" ]]; then
				clean_pending=$((clean_pending + 1))
				remove_item "$link" "${_colors[error]}Removing broken symlink (not from dotfiles)${_colors[reset]} $desc"
			else
				log "${_colors[warn]}broken symlink (not from dotfiles, use --foreign to remove)${_colors[reset]} $desc"
			fi
		fi
	done < <(command find "$dir/" -mindepth 1 -maxdepth 1 -type l -print0)

	[[ $found == 0 ]] && log_verbose "${_colors[success]}no stale symlinks in${_colors[reset]} ${_colors[target]}$dir${_colors[reset]}"
	return 0
}
