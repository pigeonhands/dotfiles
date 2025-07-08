autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit

source ~/.config/zsh/plugins.zsh
source ~/.config/zsh/smc-theme.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/exports.zsh
source ~/.cargo/env

source $HOME/.local/bin/env

#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#fpath = ($ZSH_CACHE_DIR/completions $fpath)



source <(jj util completion zsh)
source /usr/share/doc/fzf/examples/key-bindings.zsh


keys_file="$HOME/.config/ai/keys.sh"

if [[ -f "$keys_file" ]]; then
  source "$keys_file"
fi

