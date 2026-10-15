command -v rg >/dev/null  && alias grep='rg'
# command fd && alias find='fd'
command -v batcat >/dev/null && alias cat='batcat'
command -v bat >/dev/null && alias cat='bat'


if command -v eza >/dev/null; then
    alias l='eza'
    alias la='eza -a'
    alias ll='eza -lah'
    alias ls='eza --color=auto'
    alias tree='eza --tree'
fi

function y() {
	local tmp cwd; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true
	command rm -f -- "$tmp"
}

# function to rename tmux window to ssh connection
ssh() {
    if [[ -n "$TMUX" && -t 0 ]]; then
        local target_host=""
        for arg in "$@"; do
            if [[ "$arg" != -* ]]; then
                target_host="$arg"
                break
            fi
        done
        
        target_host="${target_host#*@}"
        
        if [[ -n "$target_host" ]]; then
            # Target ONLY the current window (-w / set-window-option)
            tmux set-window-option automatic-rename off >/dev/null 2>&1
            tmux rename-window "ssh:$target_host"
        fi
        
        command ssh "$@"
        
        # Re-enable automatic-rename specifically for this window upon exit
        tmux set-window-option automatic-rename on >/dev/null 2>&1
    else
        command ssh "$@"
    fi
}
