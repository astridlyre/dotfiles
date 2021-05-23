#!/bin/bash

# If not running interactively, do nothing
[[ $- != *i* ]] && return

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

# Source files
if [[ -d ~/.bashrc.d ]]; then
  for file in ~/.bashrc.d/*; do
    [[ -f "$file" ]] && . "$file"
  done
  unset file
fi

# enable programmable completion features
if ! shopt -oq posix; then
	[[ -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
fi
