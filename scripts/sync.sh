# run with ./setup.sh sync

sync_dotfiles "common"
hostname="$(hostname -s)"
[[ -d "$hostname" ]] && sync_dotfiles "$hostname" || true
