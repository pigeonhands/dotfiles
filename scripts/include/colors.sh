# Shared colour palette (bash 4+).
#
# Source this from any script that wants coloured output:
#
#     source "$scripts/include/colors.sh"
#     echo -e "${_colors[success]}done${_colors[reset]}"
#
# Use `echo -e` (or printf %b) when the escapes sit inside a larger string.
declare -gA _colors=(
	[reset]=$'\e[0m'
	[bold]=$'\e[1m'
	[dim]=$'\e[2m'
	[success]=$'\e[32m' # Used when things are already correct / up-to-date
	[action]=$'\e[33m'  # Used when performing a state change (e.g., Symlinking)
	[warn]=$'\e[33m'    # Used for things that need attention (dry run, wrong target)
	[error]=$'\e[31m'   # Used for deletions, destructive steps and problems
	[skip]=$'\e[35m'    # Used when skipping due to safety checks
	[target]=$'\e[36m'  # Used for paths, files, and symlink targets
	[info]=$'\e[36m'    # Used for neutral labels (e.g., "Applying", "diff")
	[heading]=$'\e[34m' # Used for section banners
)
