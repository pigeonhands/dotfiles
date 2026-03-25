if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=remote/ssh
fi

set -o vi

export SESSION_TYPE="$SESSION_TYPE"

# Where to save the history file
HISTFILE=~/.zsh_history

# How many lines to keep in the current session
HISTSIZE=10000

# How many lines to save in the actual file
SAVEHIST=10000

source ~/.config/zsh/plugins.zsh
source ~/.config/zsh/smc-theme.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/exports.zsh

autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit


#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#fpath = ($ZSH_CACHE_DIR/completions $fpath)



command -v zoxide >/dev/null && source <(zoxide init zsh)
command -v jj >/dev/null && source <(jj util completion zsh)

if [[ -f "~/.cargo/env" ]]; then
    source ~/.cargo/env
fi

if [[ -f "~/.local/bin/env" ]]; then
    source ~/.local/bin/env
fi

eval "$(fzf --zsh)"

export SSH_ENV="$XDG_RUNTIME_DIR/ssh-agent.env"

function start_agent {
    /usr/bin/ssh-agent -t 1h >| "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    source "${SSH_ENV}" > /dev/null
}

if [ -f "${SSH_ENV}" ]; then
    source "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

keys_file="$HOME/.config/ai/keys.sh"

if [[ -f "$keys_file" ]]; then
  source "$keys_file"
fi

