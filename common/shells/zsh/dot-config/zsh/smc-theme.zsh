autoload -U colors && colors
setopt PROMPT_SUBST
export VIRTUAL_ENV_DISABLE_PROMPT=1

ZSH_THEME_VIRTUALENV_PREFIX="(%{$fg[magenta]%}"
ZSH_THEME_VIRTUALENV_SUFFIX="%{$fg[blue]%})"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} +"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ✱"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✗"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} ➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} ✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[blue]%} ✈"
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"

function virtualenv_prompt_info() {
  [[ -n ${VIRTUAL_ENV} ]] || return
  echo "${ZSH_THEME_VIRTUALENV_PREFIX=[}${VIRTUAL_ENV_PROMPT:-${VIRTUAL_ENV:t:gs/%/%%}}${ZSH_THEME_VIRTUALENV_SUFFIX=]}"
}

function git_prompt_short_sha() {
  local SHA
  SHA=$(git rev-parse --short HEAD 2>/dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

function git_prompt_status() {
  local status_text
  status_text="$(git status --porcelain -b 2>/dev/null)" || return 1

  local -A statuses_seen
  git rev-parse --verify refs/stash &>/dev/null && statuses_seen[STASHED]=1

  local status_lines=("${(@f)${status_text}}")
  if [[ "$status_lines[1]" =~ "^## [^ ]+ \[(.*)\]" ]]; then
    local branch_statuses=("${(@s/,/)match}")
    for branch_status in $branch_statuses; do
      [[ $branch_status =~ "(behind|diverged|ahead) ([0-9]+)?" ]] || continue
      statuses_seen[$match[1]]=1
    done
  fi

  local -A prefix_map=(
    '\?\? ' UNTRACKED  'A  ' ADDED    'M  ' MODIFIED  'MM ' MODIFIED
    ' M '   MODIFIED   'AM ' MODIFIED ' T ' MODIFIED  'R  ' RENAMED
    ' D '   DELETED    'D  ' DELETED  'UU ' UNMERGED
  )
  for prefix constant in "${(@kv)prefix_map}"; do
    [[ "$status_text" =~ "^${prefix}" ]] && statuses_seen[$constant]=1
  done

  local -A prompt_map=(
    UNTRACKED "$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    ADDED     "$ZSH_THEME_GIT_PROMPT_ADDED"
    MODIFIED  "$ZSH_THEME_GIT_PROMPT_MODIFIED"
    RENAMED   "$ZSH_THEME_GIT_PROMPT_RENAMED"
    DELETED   "$ZSH_THEME_GIT_PROMPT_DELETED"
    STASHED   "$ZSH_THEME_GIT_PROMPT_STASHED"
    UNMERGED  "$ZSH_THEME_GIT_PROMPT_UNMERGED"
    AHEAD     "$ZSH_THEME_GIT_PROMPT_AHEAD"
    BEHIND    "$ZSH_THEME_GIT_PROMPT_BEHIND"
    DIVERGED  "$ZSH_THEME_GIT_PROMPT_DIVERGED"
  )
  local output=""
  for c in UNTRACKED ADDED MODIFIED RENAMED DELETED STASHED UNMERGED AHEAD BEHIND DIVERGED; do
    [[ -n "${statuses_seen[$c]}" ]] && output+="${prompt_map[$c]}"
  done
  echo "$output"
}

function myjj() {
    if command -v jj >/dev/null; then
	    jj_ref="$(jj log -r @ \
		--template '
	    separate(" ",
		label("bookmarks", if(self.bookmarks(), separate(" ", self.bookmarks()))),
		format_short_change_id(self.change_id()),
	    )
	    ' --no-graph --color=always \
	    2&>/dev/null
	    )" || return

	    echo "─$fg[green]%B[%{$reset_color%}$fg[purple]%B$jj_ref%{$reset_color%}%b%B$fg[green]]%b"
    fi
}

function mygit() {
  if [[ "$(git config --get oh-my-zsh.hide-status)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
    echo "─$fg[green]%B[${ref#refs/heads/}$(git_prompt_short_sha)$( git_prompt_status )%{$reset_color%}%b%B$fg[green]]%b"
  fi
}

function svc_prompts() {
    echo "$(mygit)$(myjj)"
}

function preexec() {
	timer=${timer:-$SECONDS}
}

function precmd() {
# 	if [ $timer ]; then
# 		timer_show=$(($SECONDS - $timer))
# 		# export RPROMPT=$'%{\e[35m%}${timer_show}s%{$reset_color%}'
# 		export RPROMPT=$'%(?:%{\e[35m%}${timer_show}s:%{$fg[red]%}${timer_show}s)%{$reset_color%}'
# 		unset timer
# 	else
# 		export RPROMPT=""
# 	fi
}

function retcode() {}

prompt_metadata="$(virtualenv_prompt_info)"
SHELL_LEVEL=$(($SHLVL - 1))

if [ -n "$TMUX" ]; then
    SHELL_LEVEL=$(("$SHELL_LEVEL" - 1))
fi

if [[ "$SHELL_LEVEL" -gt 0 ]]; then
    prompt_metadata+="%{$fg[green]%}[%{$fg[magenta]%}$SHELL_LEVEL%{$fg[green]%}]─"
fi

if [ "$SESSION_TYPE" = "remote/ssh" ]; then
    prompt_metadata+="%{$fg[red]%}[%{$fg[black]%}SSH%{$fg[red]%}]─"
fi

local user_string="%{$fg[yellow]%}%B%n%b$fg[white]@%{$fg[blue]%}%B%m%b"
local path_string="%{$fg[white]%}%B%~%b"
local user_and_path_string="${user_string}:${path_string}"
local prompt_string="%(!.#.$)"
local first_line='%{$fg[green]%}┬─$prompt_metadata%{$fg[green]%}[${user_and_path_string}%{$fg[green]%}]─[%{$fg[cyan]%}$(date +%X)%{$fg[green]%}]$(svc_prompts)'
local second_line='%{$fg[green]%}╰─>%{$fg[red]%}%1{${prompt_string}%}'


NEWLINE=$'\n'
PROMPT="${first_line}${NEWLINE}${second_line}%b%{$reset_color%} "
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '
