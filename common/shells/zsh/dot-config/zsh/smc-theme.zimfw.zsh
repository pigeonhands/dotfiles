# vim:et sts=2 sw=2 ft=zsh

_prompt_asciiship_vimode() {
  case ${KEYMAP} in
    vicmd) echo -n '%S%#%s' ;;
    *) echo -n '%#' ;;
  esac
}

if (( ! ${+functions[_prompt_asciiship_keymap_select]} )); then
  functions[_prompt_asciiship_keymap_select]=${widgets[zle-keymap-select]#user:}'
zle reset-prompt
zle -R'
  zle -N zle-keymap-select _prompt_asciiship_keymap_select
fi

typeset -g VIRTUAL_ENV_DISABLE_PROMPT=1

setopt nopromptbang prompt{cr,percent,sp,subst}

autoload -Uz add-zsh-hook

# Depends on prompt-pwd module to show formatted current directory
if (( ${+functions[prompt-pwd]} )); then
  zstyle ':zim:prompt-pwd:git-root' format '%U%d%u'
else
  functions[prompt-pwd]='print ${(D)PWD}'
fi
# Depends on duration-info module to show last command duration
if (( ${+functions[duration-info-preexec]} && ${+functions[duration-info-precmd]} )); then
  zstyle ':zim:duration-info' format ' took %B%F{yellow}%d%f%b'
  add-zsh-hook preexec duration-info-preexec
  add-zsh-hook precmd duration-info-precmd
fi
# Depends on git-info module to show git information
typeset -gA git_info
if (( ${+functions[git-info]} )); then
  zstyle ':zim:git-info:branch' format '%b'
  zstyle ':zim:git-info:commit' format 'HEAD %F{green}(%c)'
  zstyle ':zim:git-info:action' format ' %F{yellow}(${(U):-%s})'
  zstyle ':zim:git-info:stashed' format '\$'
  zstyle ':zim:git-info:unindexed' format '!'
  zstyle ':zim:git-info:indexed' format '+'
  zstyle ':zim:git-info:ahead' format '>'
  zstyle ':zim:git-info:behind' format '<'
  zstyle ':zim:git-info:keys' format \
      'status' '%S%I%i%A%B' \
      'prompt' ' on %%B%F{magenta}%b%c%s${git_info[status]:+" %F{red}[${(e)git_info[status]}]"}%f%%b'
  add-zsh-hook precmd git-info
fi

function _is_in_terminal_emulator() {
    local tree
    tree="$(pstree -s $$ 2>/dev/null)" || return 1

    # List of common terminal emulators to look for in the ancestry
    local term_emulators=(foot kitty alacritty wezterm ghostty gnome-terminal konsole st urxvt xterm)
    
    for term in "${term_emulators[@]}"; do
        if [[ "$tree" == *"$term"* ]]; then
            return 0 # Found a terminal emulator in the ancestry
        fi
    done
    return 1
}

function prompt_shlvl() {
    local shell_level=$(($SHLVL - 1))
    

    # Normalize terminal emulator
    [[ _is_in_terminal_emulator ]] && shell_level=$((shell_level - 1))

    # Normalize tmux baseline
    [[ -n "$TMUX" ]] && shell_level=$((shell_level - 1))

    # If we are genuinely nested, print the level directly
    if [[ "$shell_level" -gt 0 ]]; then
        echo -n "%B%F{yellow}($shell_level)%f%b "
    fi

    #echo -n "%(2L.%B%F{yellow}(%L)%f%b .)" # original prompt
}

# 2. User & Host (SSH Context)
function prompt_user_host() {
    echo -n "%(!.%B%F{red}%n%f%b in .${SSH_TTY:+"%B%F{yellow}%n%f%b in "})${SSH_TTY:+"%B%F{green}%m%f%b in "}"
}

# 3. Working Directory
function prompt_dir() {
    echo -n "%B%F{cyan}$(prompt-pwd)%f%b"
}

# 4. Jujutsu VCS
function myjj() {
    command -v jj >/dev/null 2>&1 || return
    local jj_ref
    jj_ref="$(jj log -r @ \
      --template '
      separate(" ",
        label("bookmarks", if(self.bookmarks(), separate(" ", self.bookmarks()))),
        format_short_change_id(self.change_id()),
      )
      ' --no-graph --color=always 2>/dev/null)" || return

    [[ -n "$jj_ref" ]] && echo -n " %F{purple}${jj_ref}%f"
}

# 5. Python Virtual Environment
function my_venv() {
    [[ -n "$VIRTUAL_ENV" ]] || return
    echo -n " %F{magenta}(${VIRTUAL_ENV_PROMPT:-${VIRTUAL_ENV:t}})%f"
}

# 6. Combined Dynamic Services (Git, JJ, Python Venv)
function svc_prompts() {
    local git_out="${(e)git_info[prompt]}"
    [[ -n "$git_out" ]] && echo -n "$git_out"
    myjj
    my_venv
}

# 7. Command Execution Time
function prompt_duration() {
    echo -n "${duration_info}"
}

# 8. Second Line (Status, Jobs, Vi-Mode)
function prompt_second_line() {
    echo -n "%B%(1j.%F{blue}*%f .)%(?.%F{green}.%F{red}%? )$(_prompt_asciiship_vimode)%f%b "
}

# ==============================================================================
# PROMPT ASSEMBLY
# ==============================================================================

PS1='
$(prompt_shlvl)%{$fg[cyan]%}$(prompt_user_host)$(prompt_dir)$(svc_prompts)$(prompt_duration)
$(prompt_second_line)'

unset RPS1
