#!/bin/bash
#                             _ _       _     _
# _ __ ___   ___   ___  _ __ | (_) __ _| |__ | |_
#| '_ ` _ \ / _ \ / _ \| '_ \| | |/ _` | '_ \| __|
#| | | | | | (_) | (_) | | | | | | (_| | | | | |_
#|_| |_| |_|\___/ \___/|_| |_|_|_|\__, |_| |_|\__|
#                                 |___/
#     /\-/\
#    /a a  \                                 _
#   =\ Y  =/-~~~~~~-,_______________________/ )
#     '^--'          ________________________/
#       \           / my wonderful bashrc
#       ||  |---'\  \
#      (_(__|   ((__|
#

# If not running interactively, do nothing
[[ $- != *i* ]] && return

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=20000

# Set some global variables
export VISUAL="/usr/local/bin/nvim"
export EDITOR="/usr/local/bin/nvim"
export FCEDIT="$EDITOR"
export PAGER="bat --theme='ansi' --tabs 4"
export MANPAGER="less -J -i -x4"
export MANWIDTH=100
export BG_IMAGE="$HOME/Pictures/Wallpapers/fishbg.jpg"
export SXHKD_SHELL=/bin/sh
export LESS_TERMCAP_mb=$'\e[1;34m'
export LESS_TERMCAP_md=$'\e[1;35m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;35m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;34m'
GPG_TTY="$(tty)"
export GPG_TTY

# A few RegExp variables because I hate typing them
export MATCH_IP='([0-9]{1,3}\.){3}[0-9]{1,3}'

# shopt
shopt -s histappend   # don't overwrite history
shopt -s checkwinsize # check for resize
shopt -s globstar     # use for recursive search
shopt -s autocd       # change to named dir
shopt -s cdspell      # fix misspellings
shopt -s dirspell     # fix misspellings

# Ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

# Default umask, recommended for security
umask 0077

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ensure prompt has colors
export color_prompt=yes

# Get color sequence for exit code
get_exit_color() {
  if (($? > 0)); then
    printf '\e[1;31m'
  else
    printf '\e[1;32m'
  fi
}

# Make nice exit codes
if [[ -n "$DISPLAY" ]]; then
  PROMPT_ICON='❱'
else
  PROMPT_ICON='$'
fi

# Prompt
PS1='\n\[\e[0;35m\]\w\n\[$(get_exit_color)\]  \[\e[1;30m\]${PROMPT_ICON}\[\e[0m\] '
PS2="〉"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# import aliases
if [ -f "$HOME/.bash_aliases" ]; then
	source "$HOME/.bash_aliases"
fi

# enable programmable completion features
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# basic PATH
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# local scripts dir
export PATH=$HOME/.bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH

# go
export PATH=/usr/local/go/bin:$PATH
export PATH=$HOME/go/bin:$PATH

# fzf
[ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"

# fnm
export PATH=$HOME/.fnm:$PATH
eval "$(fnm env)"

# zoxide
eval "$(zoxide init bash)"

# ruby
export PATH=${PATH}:${HOME}/.local/share/gem/ruby/2.7.0/bin

# bat theme
export BAT_THEME='ansi'

# NNN
export NNN_COLORS='5555'
export NNN_FCOLORS='0A0B0C02000D0E0809030601'

# fzf colors
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=fg:#b2b2b2,hl:#D1616B
--color=fg+:#b2b2b2,hl+:#8DA54E
--color=info:#CAD4C8,prompt:#8DA54E
--color=marker:#774051,spinner:#8DA54E'
