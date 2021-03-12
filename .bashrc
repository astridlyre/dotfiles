#!/bin/bash
#                             _ _       _     _
# _ __ ___   ___   ___  _ __ | (_) __ _| |__ | |_
#| '_ ` _ \ / _ \ / _ \| '_ \| | |/ _` | '_ \| __|
#| | | | | | (_) | (_) | | | | | | (_| | | | | |_
#|_| |_| |_|\___/ \___/|_| |_|_|_|\__, |_| |_|\__|
#                                 |___/
#

# If not running interactively, do nothing
[[ $- != *i* ]] && return

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# Set some global variables
export VISUAL="/usr/local/bin/nvim"
export EDITOR="/usr/local/bin/nvim"
export FCEDIT="$EDITOR"
export PAGER="/usr/bin/less"
export MANPAGER="nvim -c 'set ft=man' -"
export MANWIDTH=90
export BG_IMAGE="$HOME/Pictures/bg2.jpg"

# A few RegExp variables because I hate typing them
export MATCH_IP='([0-9]{1,3}\.){3}[0-9]{1,3}'

# shopt
shopt -s histappend   # don't overwrite history
shopt -s checkwinsize # check for resize
shopt -s globstar     # use for recursive search
shopt -s autocd       # change to named dir
shopt -s cdspell      # fix misspellings

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
    printf '\e[31m'
  else
    printf '\e[32m'
  fi
}

# Make nice exit codes
EXIT_CODE=0
get_exit_code() {
  EXIT_CODE=$?
}

# Prompt
PS1='\n\[\e[0;37m\]\w\n\[$(get_exit_color)\]${EXIT_CODE}\[\e[0m\] \[\e[0;30;1m\]❱\[\e[0m\] '
PS2="〉"
PROMPT_COMMAND="get_exit_code"

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
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

# local scripts dir
export PATH=$HOME/.bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# go
export PATH=/usr/local/go/bin:$PATH
export PATH=$HOME/go/bin:$PATH

# fzf
[ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"

# fnm
export PATH=$HOME/.fnm:$PATH
eval "$(fnm env)"

# ruby
export PATH=$HOME/.local/share/gem/ruby/2.7.0/bin:$PATH
