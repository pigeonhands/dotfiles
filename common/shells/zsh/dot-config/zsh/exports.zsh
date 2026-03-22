export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Homebrew (macOS) — must come before /bin so newer bash is picked up
if [ -d "/opt/homebrew/bin" ]; then
    export PATH="/opt/homebrew/bin:$PATH"
elif [ -d "/usr/local/homebrew/bin" ]; then
    export PATH="/usr/local/homebrew/bin:$PATH"
fi


if command -v nvim >/dev/null; then
    export EDITOR="nvim"
    export MANPAGER='nvim +Man!'
fi

FNM_PATH="/home/sam/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/sam/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
