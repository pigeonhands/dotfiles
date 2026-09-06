sync_dotfiles "common"

hostname="$(hostname -s)"
[[ -d "machines/$hostname" ]] && sync_dotfiles "machines/$hostname" || true
