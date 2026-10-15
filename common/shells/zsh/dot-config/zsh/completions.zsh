if [ "$ZSH_PLUGIN_MANAGER" != "zimfw" ]; then
    autoload -U compinit && compinit
    autoload -U bashcompinit && bashcompinit

    if command -v fzf >/dev/null; then
        # Only run fzf --zsh if the binary supports it (v0.48.0+)
        if [[ $(fzf --version 2>/dev/null | awk '{print $1}') > "0.48.0" ]]; then
            eval "$(fzf --zsh)"
        else
            # Fallback for older package-manager versions of fzf
            [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
            [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
        fi
    fi
fi

#zstyle ':fzf-tab:*' group-colors $'\e[33m' $'\e[34m' $'\e[35m' $'\e[36m'
#zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:descriptions' format ''

command -v zoxide >/dev/null && source <(zoxide init zsh)
command -v jj >/dev/null && source <(jj util completion zsh)

command -v niri >/dev/null && source <(niri completions zsh | sed "s/line\[2\]/line[1]/g; /'::command/d")

if command -v noctalia >/dev/null; then
    source <(noctalia completions zsh | head -n -1)
    compdef _noctalia noctalia
fi
