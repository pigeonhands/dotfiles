export MANPAGER='nvim +Man!'

export PATH="$HOME/.local/bin:$PATH"

FNM_PATH="/home/sam/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/sam/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
