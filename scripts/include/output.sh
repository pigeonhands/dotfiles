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
