ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  
  if [[ ! -e ${ZIM_HOME}/init.zsh ]]; then
    source ${ZIM_HOME}/zimfw.zsh init -q
  fi
fi

# Automatically rebuild Zimfw if .zimrc was modified since the last build
if [[ ~/.zimrc -nt ${ZIM_HOME}/init.zsh ]]; then
    echo "Updating Zimfw build from modified .zimrc..."
    source ${ZIM_HOME}/zimfw.zsh build -q
fi

source ${ZIM_HOME}/init.zsh
