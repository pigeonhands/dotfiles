if [ "$ZSH_PLUGIN_MANAGER" != "zimfw" ]; then
    autoload -U compinit && compinit
    autoload -U bashcompinit && bashcompinit

    eval "$(fzf --zsh)"
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
