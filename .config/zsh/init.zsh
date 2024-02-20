autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit

source ~/.config/zsh/plugins.zsh
source ~/.config/zsh/smc-theme.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/exports.zsh
source ~/.cargo/env

[ -x "$(command -v foo)" ] || source <(kubectl completion zsh)
# fpath = ($ZSH_CACHE_DIR/completions $fpath)
