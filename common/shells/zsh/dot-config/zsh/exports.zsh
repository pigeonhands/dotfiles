typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    $path
)

# Homebrew integration (macOS)
if [[ -d "/opt/homebrew/bin" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
elif [[ -d "/usr/local/homebrew/bin" ]]; then
    export PATH="/usr/local/homebrew/bin:$PATH"
fi

# Editor & Manpage settings
if command -v nvim >/dev/null; then
    export EDITOR="nvim"
    export MANPAGER='nvim +Man!'
    export DIFFPROG="nvim -d"
fi

# Node Version Manager (fnm)
FNM_PATH="$HOME/.local/share/fnm"
if [[ -d "$FNM_PATH" ]]; then
    export PATH="$FNM_PATH:$PATH"
    eval "$(fnm env)"
fi

# Node Version Manager (nvm)
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"
