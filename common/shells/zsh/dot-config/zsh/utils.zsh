function smc_debug_log() {
    (( ZSH_SMC_DEBUG > 0 )) && echo "[ZSH-DEBUG] $@"
}

function smc_source_config_file() {
    local file_path="$ZSH_DOTFILES_DIR/$1"

    smc_debug_log "? Looking for $file_path"
    if [[ -f "$file_path" ]]; then
        smc_debug_log "+ Loading $file_path"
        source "$file_path"
    fi
}

function load_if_exists() {
    local config_file="$1"
    local pluginmgr="${2:-$ZSH_PLUGIN_MANAGER}"

    local no_load_var="SMC_NO_LOAD_${(U)config_file}"

    if [[ -n "${(P)no_load_var}" ]] && (( "${(P)no_load_var}" > 0 )); then
        smc_debug_log "- Skipping $config_file (disabled via environment override $no_load_var)"
        return 0
    fi

    smc_source_config_file "$config_file.zsh"
    smc_source_config_file "pluginmngr.d/$pluginmgr/$config_file.zsh"
}

function smc_swap_pluginmgr() {
    local target_pm="$1"

    if [[ -z "$target_pm" ]]; then
        if ! command -v fzf >/dev/null; then
            echo "Error: fzf is required for interactive selection." >&2
            return 1
        fi

        target_pm=$(print -l $ZSH_AVALIBLE_PLUGIN_MANAGERS | \
            fzf --height=6 --layout=reverse --prompt="Select Plugin Manager > ")

        [[ -z "$target_pm" ]] && return 0
    fi

    smc_debug_log "Swapping plugin manager to: $target_pm"
    ZSH_PLUGIN_MANAGER="$target_pm" exec zsh
}

function smc_reload_sh() {
    exec $(readlink /proc/$$/exe)
}
