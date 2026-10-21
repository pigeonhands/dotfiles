bindkey -v
set -o vi
typeset -aU path

ZSH_AUTOSUGGEST_USE_ASYNC=true

ZSH_AVALIBLE_PLUGIN_MANAGERS=(zimfw antidote)

ZSH_SMC_DEBUG=${ZSH_SMC_DEBUG:-0}
ZSH_PLUGIN_MANAGER="${ZSH_PLUGIN_MANAGER:-${ZSH_AVALIBLE_PLUGIN_MANAGERS[1]}}"

ZSH_DOTFILES_DIR="${0:a:h}"

[[ -f "$ZSH_DOTFILES_DIR/utils.zsh" ]] && source "$ZSH_DOTFILES_DIR/utils.zsh"

smc_debug_log "ZSH_PLUGIN_MANAGER=$ZSH_PLUGIN_MANAGER"
smc_debug_log "ZSH_DOTFILES_DIR=$ZSH_DOTFILES_DIR"

load_if_exists "plugins"
load_if_exists "completions"
load_if_exists "aliases"
load_if_exists "exports"
load_if_exists "session"
load_if_exists "theme"
