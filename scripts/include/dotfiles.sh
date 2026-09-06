if [[ -z "$DOTFILE_HOME" ]]; then
	echo "DOTFILE_HOME must be set" >&2
	exit 1
fi

DOTFILES_DRY_RUN="${DOTFILES_DRY_RUN:-1}"
DOTFILES_FORCE="${DOTFILES_FORCE:-0}"
DOTFILES_FILTER="${DOTFILES_FILTER:-}"
DOTFILES_CACHE_DIR="${DOTFILES_CACHE_DIR:-$PWD/.dotfiles-cache}"
DOTFILES_BACKUP_DIR="${DOTFILES_BACKUP_DIR:-$PWD/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)}"
DOTFILES_ACTION="${DOTFILES_ACTION:-sync}"

AGE_KEY_FILE="${AGE_KEY_FILE:-$HOME/.age/key.txt}"
AGE_RECIPIENTS_FILE="${AGE_RECIPIENTS_FILE:-$PWD/.age-recipients}"

SPECIAL_DOTFILES="fold|root"
log_tab_index="0"

_include_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$_include_dir/output.sh"
source "$_include_dir/util.sh"
source "$_include_dir/symlink.sh"
source "$_include_dir/actions.sh"
source "$_include_dir/walk.sh"

unset _include_dir
