# run with ./setup.sh sync

sync_dotfiles "common"
hostname="$(cat /etc/hostname)"
[[ -d "$hostname" ]] && sync_dotfiles "$hostname" || true
