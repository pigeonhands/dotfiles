if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting
    echo The time is (set_color yellow; date +%T; set_color normal) and this machine is called $hostname
end

alias grep='rg'
alias find=fdfind
alias cat='batcat --style=plain'
alias bat=batcat
#alias cat=bat
alias l='exa'
alias la='exa -a'
alias ll='exa -lah'
alias ls='exa --color=auto'

export MANPAGER='nvim +Man!'
export NVM_DIR="$HOME/.nvm"

function last_history_item
    echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item
