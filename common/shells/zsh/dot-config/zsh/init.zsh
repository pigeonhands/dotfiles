bindkey -v
set -o vi

ZSH_PLUGIN_MANAGER=${ZSH_PLUGIN_MANAGER:-"zimfw"}

ZIM_COMPINIT_REINITIALIZE=1
ZSH_DOTFILES_DIR="${0:a:h}"

function sorce_config_file() {
    local file_path="$ZSH_DOTFILES_DIR/$1"
    if [[ -f "$file_path" ]]; then
        source "$file_path"
    fi
}

function load_if_exists() {
    local config_file="$1"
    local variable="${2:-$ZSH_PLUGIN_MANAGER}"

    sorce_config_file "$config_file.zsh"
    sorce_config_file "$config_file.$variable.zsh"
}

load_if_exists "plugins"
load_if_exists "completions"
load_if_exists "aliases"
load_if_exists "exports"
load_if_exists "session"
load_if_exists "smc-theme"
