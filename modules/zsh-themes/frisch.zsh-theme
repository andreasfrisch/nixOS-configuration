# requires plugin 'virtualenv'

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✱"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[blue]%}✈"
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"

function mygit() {
  if [[ "$(git config --get oh-my-zsh.hide-status)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
    echo "%{\e[0;34m%}%B[ ${ref#refs/heads/} $( git_prompt_status )%{$reset_color%} %{\e[0;34m%}%B]"
  fi
}

function retcode() {}

function virtualenv_prompt_info(){
  [[ -n ${VIRTUAL_ENV} ]] || return
  echo "${ZSH_THEME_VIRTUALENV_PREFIX:=[}${VIRTUAL_ENV:t}${ZSH_THEME_VIRTUALENV_SUFFIX:=]}"
}

# custom prompt with git
PROMPT=$'%{\e[0;34m%}%B┌─ $(virtualenv_prompt_info)%{\e[0m%}%{\e[0;36m%}%m%b%{\e[0m%}: %b%{\e[1;37m%}%~%  $(mygit)
%{\e[0;34m%}%B└─ %{\e[0;34m%}%B[%b%{\e[0;33m%}'%D{"%H:%M:%S"}%b$'%{\e[0;34m%}%B]%b%{\e[0m%} '
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '

