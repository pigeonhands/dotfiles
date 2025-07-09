autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit

source ~/.config/zsh/plugins.zsh
source ~/.config/zsh/smc-theme.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/exports.zsh


#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#fpath = ($ZSH_CACHE_DIR/completions $fpath)



source <(zoxide init zsh)
source <(jj util completion zsh)

if [[ -f "~/.cargo/env" ]]; then
    source ~/.cargo/env
fi

if [[ -f "~/.local/bin/env" ]]; then
    source ~/.local/bin/env
fi

if command -v fzf-share >/dev/null; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
else
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
fi

keys_file="$HOME/.config/ai/keys.sh"

if [[ -f "$keys_file" ]]; then
  source "$keys_file"
fi

