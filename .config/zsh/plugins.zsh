
[[ ! -d "$HOME/.antigen" ]] && git clone https://github.com/zsh-users/antigen.git "$HOME/.antigen"
source "$HOME/.antigen/antigen.zsh"

# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="smc"
# source $ZSH/oh-my-zsh.sh
# source ~/.antigen.zsh


antigen use oh-my-zsh

antigen bundle git
antigen bundle pip

antigen bundle command-not-found
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions

antigen apply
