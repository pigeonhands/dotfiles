if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=remote/ssh
fi

export SESSION_TYPE="$SESSION_TYPE"

# Where to save the history file
HISTFILE=~/.zsh_history

# How many lines to keep in the current session
HISTSIZE=10000

# How many lines to save in the actual file
SAVEHIST=10000

export SSH_ENV="$XDG_RUNTIME_DIR/ssh-agent.env"


if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

if [[ -f "$HOME/.local/bin/env" ]]; then
    source "$HOME/.local/bin/env"
fi

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
