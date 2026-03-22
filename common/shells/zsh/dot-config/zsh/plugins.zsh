[[ ! -d "$HOME/.antidote" ]] && git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"

source "$HOME/.antidote/antidote.zsh"

# loads from  ~/.zsh_plugins.txt
antidote load

plugins=(
  git
  dotenv
  pip
  rust
  #ripgrep
)
