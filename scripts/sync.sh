# run with ./setup.sh sync

sync_dotfiles "common"
[[ -d "$(hostname)" ]] && sync_dotfiles "$(hostname)" || true
