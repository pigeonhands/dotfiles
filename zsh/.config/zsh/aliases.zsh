

#alias cat='batcat --style=plain'

command -v rg >/dev/null  && alias grep='rg'
# command fd && alias find='fd'

command -v batcat >/dev/null && alias cat='batcat'
command -v bat >/dev/null && alias cat='bat'


if command -v eza >/dev/null; then
    alias l='eza'
    alias la='eza -a'
    alias ll='eza -lah'
    alias ls='eza --color=auto'
fi

