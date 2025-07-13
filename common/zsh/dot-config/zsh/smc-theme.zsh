# python venv, user, host, full path and branch on two lines for easier vgrepping

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

function myjj() {
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
	if [ $timer ]; then
		timer_show=$(($SECONDS - $timer))
		# export RPROMPT=$'%{\e[35m%}${timer_show}s%{$reset_color%}'
		export RPROMPT=$'%(?:%{\e[35m%}${timer_show}s:%{$fg[red]%}${timer_show}s)%{$reset_color%}'
		unset timer
	else
		export RPROMPT=""
	fi
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
