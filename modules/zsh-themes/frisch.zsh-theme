# requires plugin 'virtualenv'

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✱"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[blue]%}✈"
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"


# Add this function to show nix shell info if inside one
function nixshell_prompt_info() {
  if [[ -n "$IN_NIX_SHELL" ]]; then
    # Prefer DEV_SHELL_NAME, fallback to DEV_SHELL, or show generic [nix-shell]
    if [[ -n "$DEV_SHELL_NAME" ]]; then
      echo "%{\e[0;33m%}[nix:${DEV_SHELL_NAME}]%{\e[0m%} "
    elif [[ -n "$DEV_SHELL" ]]; then
      echo "%{\e[0;33m%}[nix:${DEV_SHELL}]%{\e[0m%} "
    else
      echo "%{\e[0;33m%}[nix-shell]%{\e[0m%} "
    fi
  fi
}

#function mygit() {
#  if [[ "$(git config --get oh-my-zsh.hide-status)" != "1" ]]; then
#    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
#    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
#    echo "%{\e[0;34m%}%B[git:${ref#refs/heads/}$( git_prompt_status )%{$reset_color%}%{\e[0;34m%}%B]"
#  fi
#}

function mygit() {
  # Don't show anything if hidden by config
  if [[ "$(git config --get oh-my-zsh.hide-status)" == "1" ]]; then
    return
  fi

  # Make sure we are in a git repo
  git rev-parse --is-inside-work-tree &>/dev/null || return

  local branch status_str added modified deleted untracked clean
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) || branch=$(git rev-parse --short HEAD 2>/dev/null)

  # Get status counts
  added=$(git diff --cached --name-status | grep '^A' | wc -l)
  modified=$(git diff --cached --name-status | grep '^M' | wc -l)
  deleted=$(git diff --cached --name-status | grep '^D' | wc -l)
  untracked=$(git ls-files --others --exclude-standard | wc -l)

  # Total unstaged changes (not staged)
  local unstaged
  unstaged=$(git diff --name-only | wc -l)

  # Build status string with icons and counts if >0
  status_str=""

  [[ $added -gt 0 ]] && status_str+=" ${ZSH_THEME_GIT_PROMPT_ADDED}${added}"
  [[ $modified -gt 0 ]] && status_str+=" ${ZSH_THEME_GIT_PROMPT_MODIFIED}${modified}"
  [[ $deleted -gt 0 ]] && status_str+=" ${ZSH_THEME_GIT_PROMPT_DELETED}${deleted}"
  [[ $unstaged -gt 0 ]] && status_str+=" ${ZSH_THEME_GIT_PROMPT_MODIFIED}${unstaged}"
  [[ $untracked -gt 0 ]] && status_str+=" ${ZSH_THEME_GIT_PROMPT_UNTRACKED}${untracked}"

  # Clean working tree icon if no changes
  if [[ -z "$status_str" ]]; then
    status_str="%{$fg[green]%}✔%{$reset_color%}"
  fi

  echo "%{\e[0;34m%}%B[git:${branch}${status_str}%{$reset_color%}%{\e[0;34m%}%B]"
}

function retcode() {}

function virtualenv_prompt_info(){
  [[ -n ${VIRTUAL_ENV} ]] || return
  echo "${ZSH_THEME_VIRTUALENV_PREFIX:=[}${VIRTUAL_ENV:t}${ZSH_THEME_VIRTUALENV_SUFFIX:=]}"
}

# custom prompt with git
PROMPT=$'%{\e[0;34m%}%B┌─ %{\e[0m%}%{\e[0;36m%}%m%b%{\e[0m%}: %b%{\e[1;37m%}%~%  $(virtualenv_prompt_info)$(nixshell_prompt_info)$(mygit)
%{\e[0;34m%}%B└─ %{\e[0;34m%}%B[%b%{\e[0;33m%}'%D{"%H:%M:%S"}%b$'%{\e[0;34m%}%B]%b%{\e[0m%} '
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '

