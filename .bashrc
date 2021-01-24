#                             _ _       _     _
# _ __ ___   ___   ___  _ __ | (_) __ _| |__ | |_
#| '_ ` _ \ / _ \ / _ \| '_ \| | |/ _` | '_ \| __|
#| | | | | | (_) | (_) | | | | | | (_| | | | | |_
#|_| |_| |_|\___/ \___/|_| |_|_|_|\__, |_| |_|\__|
#                                 |___/
#
# Make sure running interactively
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
NUMMONS=$(xrandr --query | rg " connected" | cut -d" " -f1 | wc -l)

# Set visual editor
VISUAL="/usr/bin/vim"
EDITOR="/usr/local/bin/nvim"
# Append history
shopt -s histappend
# Check if window resized
shopt -s checkwinsize
# Use ** for recursive matching
shopt -s globstar
umask 022
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# ensure prompt has colors
color_prompt=yes

# Nice colored directory listing above prompt
PS1='\n\[\033[01;34m\]\w\[\033[00m\]\n\[\033[0;37m\]❱\[\033[00m\] '
PS2="〉"

# enable color support of grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# import aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# fnm
export PATH=/home/ml/.fnm:/home/ml/.local/bin:/home/ml/.local/kitty.app/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/ml/.bin

# go
export PATH=/usr/local/go/bin:$PATH
# scripts
export PATH=/home/ml/scripts:$PATH

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# fnm
export PATH=/home/ml/.fnm:$PATH
eval "`fnm env`"

if [ ! $VIM ]; then
  elfman
fi
