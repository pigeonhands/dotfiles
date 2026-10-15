SESSION_TYPE="local"
[[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]] && SESSION_TYPE="remote/ssh"
export SESSION_TYPE

export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

local -a env_files=(
    "$HOME/.cargo/env"
    "$HOME/.local/bin/env"
    "$HOME/.config/ai/keys.sh"
)

for env_file in $env_files; do
    [[ -f "$env_file" ]] && source "$env_file"
done

export SSH_ENV="${XDG_RUNTIME_DIR:-${HOME}/.cache}/ssh-agent.env"

function start_agent() {
    /usr/bin/ssh-agent -t 1h >| "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    source "${SSH_ENV}" > /dev/null
}

if [[ -f "${SSH_ENV}" ]]; then
    source "${SSH_ENV}" > /dev/null
    if [[ -z "$SSH_AGENT_PID" ]] || ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
        start_agent
    fi
else
    start_agent
fi
